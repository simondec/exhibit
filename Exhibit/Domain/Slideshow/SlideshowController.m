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
#import "UIImage+ProportionalFill.h"
#import "TTTTimeIntervalFormatter.h"
#import "UIImage+BlurredFilter.h"
#import "AUBAvatar.h"
#import "TTTTimeIntervalFormatter.h"

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
@property (nonatomic) TTTTimeIntervalFormatter *timeIntervalFormatter;
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

        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        self.timeIntervalFormatter.presentTimeIntervalMargin = 60;
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
    [AUBMoment listFromOrganization:self.configuration.organizationID amount:self.configuration.slideCount from:nil completion:^(NSArray *array, NSError *error) {
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
    __weak typeof(self) wSelf = self;
    [AUBMoment listFromOrganization:self.configuration.organizationID amount:SlideshowControllerArbitraryNewMomentsFetchCount from:nil completion:^(NSArray *array, NSError *error) {
        if (!error && [array count] > 0) {
            AUBMoment *previousLastMoment = wSelf.chronologicalMomentsInfo.firstObject;
            NSUInteger previousLastMomentIndex = [array indexOfObjectPassingTest:^BOOL(AUBMoment *moment, NSUInteger idx, BOOL *stop) {
                *stop = [moment.objectID isEqual:previousLastMoment.objectID];
                return *stop;
            }];

            if (previousLastMomentIndex == NSNotFound) {
                previousLastMomentIndex = array.count - 1;
            }

            for (NSUInteger i = 0; i < previousLastMomentIndex; i++) {
                @synchronized (wSelf.chronologicalMomentsInfo) {
                    [wSelf.chronologicalMomentsInfo insertObject:array[i] atIndex:i];
                }

                // Randomize its position
                NSUInteger randomizedIndex = arc4random_uniform(wSelf.randomizedMomentsOrder.count + 1);
                @synchronized (self.randomizedMomentsOrder) {
                    [wSelf.randomizedMomentsOrder insertObject:@(i) atIndex:randomizedIndex];
                }
            }

            NSLog(@"Did load %i new moments", previousLastMomentIndex);
        }
    }];
}

- (void)shuffleMomentsOrder
{
    NSUInteger count = [self.chronologicalMomentsInfo count];
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
        return NO;
    }

    BOOL successfullyPreparedMoment = YES;

    SDImageCache *imageCache = [SDImageCache sharedImageCache];

    AUBMoment *momentInfo = self.chronologicalMomentsInfo[index];
    Moment *moment = [Moment new];
    moment.momentDescription = momentInfo.momentDescription;
    moment.author = momentInfo.user.fullName;
    moment.relativeDate = [self.timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:momentInfo.createdAt];

    moment.media = [imageCache imageFromMemoryCacheForKey:momentInfo.media.large.absoluteString];
    if (!moment.media) {
        NSData *imageData = [NSData dataWithContentsOfURL:momentInfo.media.large];
        if (imageData == nil) {
            successfullyPreparedMoment = NO;
        }
        moment.media = [UIImage imageWithData:imageData];
    }

    if (successfullyPreparedMoment) {
        moment.blurredBackground = [[moment.media imageScaledToFitSize:CGSizeMake(450, 450)] blurredImage];
        [self.momentsData setObject:moment forKey:momentInfo.objectID];
        NSLog(@"Moment prepared successfully: %i", index);
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

    dispatch_async(dispatch_get_global_queue(DISPATCH_TARGET_QUEUE_DEFAULT, 0), ^{
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
    NSLog(@"Display moment %i", index);

    for (id <SlideshowObserver> observer in self.observers) {
        if ([observer respondsToSelector:@selector(displayMoment:atChronologicalIndex:)]) {
            [observer displayMoment:moment atChronologicalIndex:index];
        }
    }
}

@end