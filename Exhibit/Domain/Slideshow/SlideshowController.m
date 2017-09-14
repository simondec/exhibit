//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "SlideshowController.h"
#import "Settings.h"
#import "Moment.h"
#import "AUBMoment.h"
#import "AUBUser.h"
#import "SDWebImageManager.h"
#import "AUBMedia.h"
#import "AUBOrganization.h"
#import "UIImage+ProportionalFill.h"
#import "UIImage+BlurredFilter.h"

static const NSInteger SlideshowControllerArbitraryNewMomentsFetchCount = 10;

@interface SlideshowController ()
@property (nonatomic) Settings *configuration;
@property (nonatomic) NSHashTable *observers;
@property (nonatomic) NSMutableArray *chronologicalMomentsInfo;
@property (nonatomic) NSMutableArray *randomizedMomentsOrder;
@property (nonatomic) NSCache *momentsData;
@property (nonatomic) NSUInteger nextRandomizedMomentIndex;
@property (nonatomic) NSTimer *momentSwitchTimer;
@property (nonatomic) NSTimer *recentMomentsLookupTimer;
@end

@implementation SlideshowController
- (instancetype)initWithConfiguration:(Settings *)configuration
{
    if (self = [super init]) {
        _configuration = configuration;
        _observers = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        _chronologicalMomentsInfo = [NSMutableArray new];
        _randomizedMomentsOrder = [NSMutableArray new];

        _momentsData = [NSCache new];
        _momentsData.countLimit = 150;
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - Public Methods
//------------------------------------------------------------------------------

- (void)addSlideshowObserver:(id <SlideshowObserver>)observer
{
    [self.observers addObject:observer];
}

- (void)removeSlideshowObserver:(id <SlideshowObserver>)observer
{
    [self.observers removeObject:observer];
}

- (NSTimeInterval)slideDuration
{
    return self.configuration.slideDuration;
}

- (void)startSlideshow
{
    [self loadMoments];

    if (self.recentMomentsLookupTimer) {
        [self.recentMomentsLookupTimer invalidate];
    }

    self.recentMomentsLookupTimer = [NSTimer scheduledTimerWithTimeInterval:self.configuration.recentMomentsLookupInterval target:self selector:@selector(loadNewMoments) userInfo:nil repeats:YES];
}

- (NSInteger)numberOfMoments
{
    return self.chronologicalMomentsInfo.count;
}

- (NSURL *)momentMediaURLAtChronologicalIndex:(NSUInteger)index
{
    AUBMoment *moment = self.chronologicalMomentsInfo[index];
    return moment.media.thumb;
}

- (void)didSelectMomentAtChronologicalIndex:(NSUInteger)index
{
    [self.momentSwitchTimer invalidate];
    self.momentSwitchTimer = [NSTimer scheduledTimerWithTimeInterval:self.configuration.slideDuration target:self selector:@selector(displayNextMoment) userInfo:nil repeats:YES];
    [self displayMomentAtChronologicalIndex:index];
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)loadMoments
{
    __weak typeof(self) wSelf = self;
    [AUBMoment listFromOrganization:self.configuration.organization.objectID amount:self.configuration.slideCount from:nil completion:^(NSArray *array, NSError *error) {
        NSLog(@"Loaded %lu moments", (unsigned long)array.count);
        
        @synchronized (wSelf.chronologicalMomentsInfo) {
            wSelf.chronologicalMomentsInfo = [array mutableCopy];
        }

        @synchronized (wSelf.randomizedMomentsOrder) {
            [wSelf shuffleMomentsOrder];
        }

        dispatch_async(dispatch_get_main_queue(), ^{

            for (id <SlideshowObserver> observer in self.observers) {
                if ([observer respondsToSelector:@selector(didLoadMoments:)]) {
                    [observer didLoadMoments:wSelf.chronologicalMomentsInfo.count];
                }
            }

            if (array.count > 0) {
                [wSelf prepareNextMoment];
                [wSelf displayNextMoment];

                if (wSelf.momentSwitchTimer) {
                    [wSelf.momentSwitchTimer invalidate];
                }

                wSelf.momentSwitchTimer = [NSTimer scheduledTimerWithTimeInterval:wSelf.configuration.slideDuration target:wSelf selector:@selector(displayNextMoment) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:wSelf.momentSwitchTimer forMode:NSRunLoopCommonModes];
            }

        });
    }];
}

- (void)loadNewMoments
{
    NSLog(@"Looking for new moments...");
    
    __weak typeof(self) wSelf = self;
    [AUBMoment listFromOrganization:self.configuration.organization.objectID amount:self.configuration.slideCount from:nil completion:^(NSArray *array, NSError *error) {
        if (!error && [array count] > 0) {

           if (![array isEqualToArray:self.chronologicalMomentsInfo]) {
               NSUInteger previousMomentsCount = self.chronologicalMomentsInfo.count;

               NSSet *updatedSet = [NSSet setWithArray:array];
               NSMutableSet *deletions = [NSMutableSet setWithArray:self.chronologicalMomentsInfo];
               [deletions minusSet:updatedSet];

               wSelf.chronologicalMomentsInfo = [array mutableCopy];

               [deletions enumerateObjectsUsingBlock:^(AUBMoment *moment, BOOL *stop) {
                   [self.momentsData removeObjectForKey:moment.objectID];
               }];

               for (NSUInteger i = previousMomentsCount; i < self.chronologicalMomentsInfo.count; i++) {
                   NSUInteger randomizedIndex = arc4random_uniform(self.randomizedMomentsOrder.count + 1);
                   [self.randomizedMomentsOrder insertObject:@(i) atIndex:randomizedIndex];
               }
               
               NSLog(@"Loaded %lu new moments, deleted %lu moments", self.chronologicalMomentsInfo.count - previousMomentsCount, (unsigned long)deletions.count);

               dispatch_async(dispatch_get_main_queue(), ^{
                   for (id <SlideshowObserver> observer in self.observers) {
                       if ([observer respondsToSelector:@selector(didLoadMoments:)]) {
                           [observer didLoadMoments:wSelf.chronologicalMomentsInfo.count];
                       }
                   }
               });

           } else {
               NSLog(@"No changes in moments list");
           }

        } else if (error) {
            NSLog(@"Looking for new moments failed with error: %@", error.localizedDescription);
        }
    }];
}

- (void)shuffleMomentsOrder
{
    NSUInteger count = [self.chronologicalMomentsInfo count];
    [self.randomizedMomentsOrder removeAllObjects];
    for (NSUInteger i = 0; i < count; ++i) {
        NSUInteger randomizedIndex = arc4random_uniform(self.randomizedMomentsOrder.count + 1);
        [self.randomizedMomentsOrder insertObject:@(i) atIndex:randomizedIndex];
    }
}

- (void)prepareNextMoment
{

    NSUInteger chronologicalMomentIndex = [self.randomizedMomentsOrder[self.nextRandomizedMomentIndex] unsignedIntegerValue];
    AUBMoment *momentInfo = self.chronologicalMomentsInfo[chronologicalMomentIndex];
    if (![self.momentsData objectForKey:momentInfo.objectID]) {
        [self prepareMomentAtChronologicalIndex:chronologicalMomentIndex];
    }
}

- (BOOL)prepareMomentAtChronologicalIndex:(NSUInteger)index
{

    if (self.chronologicalMomentsInfo.count == 0) {
        NSLog(@"Moment could not be prepared, no moments available: %lu", (unsigned long)index);
        return NO;
    }

    BOOL successfullyPreparedMoment = YES;

    SDImageCache *imageCache = [SDImageCache sharedImageCache];

    AUBMoment *momentInfo = self.chronologicalMomentsInfo[index];
    
    if (momentInfo == nil || momentInfo.momentDescription.length == 0 || momentInfo.media == nil || momentInfo.user == nil || momentInfo.user.fullName.length == 0) {
        NSLog(@"Moment could not be prepared, data missing: %lu", (unsigned long)index);
        return NO;
    }
    
    Moment *moment = [Moment new];
    moment.momentDescription = momentInfo.momentDescription;
    moment.author = momentInfo.user.fullName;
    moment.createdAt = momentInfo.createdAt;

    moment.media = [imageCache imageFromMemoryCacheForKey:momentInfo.media.large.absoluteString];
    if (!moment.media) {
        NSData *imageData = [NSData dataWithContentsOfURL:momentInfo.media.large];
        if (imageData == nil) {
            NSLog(@"Moment could not be prepared, image missing: %lu", (unsigned long)index);
            successfullyPreparedMoment = NO;
        }
        moment.media = [UIImage imageWithData:imageData];
    }

    if (successfullyPreparedMoment) {
        moment.blurredBackground = [[moment.media imageScaledToFitSize:CGSizeMake(450, 450)] blurredImage];
        [self.momentsData setObject:moment forKey:momentInfo.objectID];
        NSLog(@"Moment prepared successfully: %lu", (unsigned long)index);
    }

    return successfullyPreparedMoment;
}

- (void)displayNextMoment
{
    NSUInteger chronologicalMomentIndex = [self.randomizedMomentsOrder[self.nextRandomizedMomentIndex] unsignedIntegerValue];
    [self displayMomentAtChronologicalIndex:chronologicalMomentIndex];

    self.nextRandomizedMomentIndex++;
    if (self.nextRandomizedMomentIndex >= self.randomizedMomentsOrder.count) {
        self.nextRandomizedMomentIndex = 0;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self prepareNextMoment];
    });
}

- (void)displayMomentAtChronologicalIndex:(NSUInteger)index
{
    AUBMoment *momentInfo = self.chronologicalMomentsInfo[index];

    BOOL canDisplayMoment = YES;

    if (![self.momentsData objectForKey:momentInfo.objectID]) {
        canDisplayMoment = [self prepareMomentAtChronologicalIndex:index];
    }

    if (!canDisplayMoment) {
        [self displayNextMoment];
        return;
    }

    Moment *moment = [self.momentsData objectForKey:momentInfo.objectID];
    NSLog(@"Display moment %lu", (unsigned long)index);

    for (id <SlideshowObserver> observer in self.observers) {
        if ([observer respondsToSelector:@selector(displayMoment:atChronologicalIndex:)]) {
            [observer displayMoment:moment atChronologicalIndex:index];
        }
    }
}

@end