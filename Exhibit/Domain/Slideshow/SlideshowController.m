//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "SlideshowController.h"
#import "Configuration.h"
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

@interface SlideshowController ()
@property (nonatomic) Configuration *configuration;
@property (nonatomic) NSArray *momentsInfo;
@property (nonatomic) NSMutableArray *randomizedMomentsInfo;
@property (nonatomic) NSMutableDictionary *randomizedMomentsData;
@property (nonatomic) NSUInteger nextMomentIndex;
@property (nonatomic) NSTimer *momentSwitchTimer;
@property (nonatomic) TTTTimeIntervalFormatter *timeIntervalFormatter;
@end

@implementation SlideshowController
- (instancetype)initWithConfiguration:(Configuration *)configuration
{
    if (self = [super init]) {
        _configuration = configuration;
        _randomizedMomentsInfo = [NSMutableArray new];
        _randomizedMomentsData = [NSMutableDictionary new];

        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        self.timeIntervalFormatter.presentTimeIntervalMargin = 60;
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - Public Methods
//------------------------------------------------------------------------------

- (void)startSlideshow
{
    [self loadMoments];
}

- (NSInteger)numberOfMoments
{
    return self.randomizedMomentsInfo.count;
}

- (Moment *)momentAtIndex:(NSUInteger)index
{
    return self.momentsInfo[index];
}

- (NSURL *)momentMediaURLAtIndex:(NSUInteger)index
{
    AUBMoment *moment = self.momentsInfo[index];
    return moment.media.large;
}

- (void)didSelectMomentAtIndex:(NSUInteger)index
{
    AUBMoment *moment = self.momentsInfo[index];
    NSUInteger tempIndex = [self.randomizedMomentsInfo indexOfObject:moment];
    [self.momentSwitchTimer invalidate];
    self.momentSwitchTimer = [NSTimer scheduledTimerWithTimeInterval:self.configuration.slideDuration target:self selector:@selector(displayNextMoment) userInfo:nil repeats:YES];
    [self displayMomentAtIndex:tempIndex];

}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)loadMoments
{
    __weak typeof(self) wSelf = self;
    [AUBMoment listFromOrganization:self.configuration.organizationID amount:self.configuration.slideCount from:nil completion:^(NSArray *array, NSError *error) {
        @synchronized (wSelf.randomizedMomentsInfo) {
            wSelf.momentsInfo = [array copy];
            wSelf.randomizedMomentsInfo = [array mutableCopy];
            [wSelf shuffleMomentsInfo];
            [wSelf prepareNextMoment];
            dispatch_async(dispatch_get_main_queue(), ^{

                if ([self.slideshowControlDelegate respondsToSelector:@selector(didLoadMoments)]) {
                    [self.slideshowControlDelegate didLoadMoments];
                }

                [wSelf displayNextMoment];
                self.momentSwitchTimer = [NSTimer scheduledTimerWithTimeInterval:self.configuration.slideDuration target:self selector:@selector(displayNextMoment) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:self.momentSwitchTimer forMode:NSRunLoopCommonModes];
            });
        }
    }];
}

- (void)shuffleMomentsInfo
{
    NSUInteger count = [self.randomizedMomentsInfo count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self.randomizedMomentsInfo exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

- (void)prepareNextMoment
{
    if (!self.randomizedMomentsData[@(self.nextMomentIndex)]) {
        [self prepareMomentAtIndex:self.nextMomentIndex];
    }
}

- (void)prepareMomentAtIndex:(NSUInteger)index
{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];

    AUBMoment *nextMoment = self.randomizedMomentsInfo[index];
    Moment *moment = [Moment new];
    moment.momentDescription = nextMoment.momentDescription;
    moment.author = nextMoment.user.fullName;
    moment.relativeDate = [self.timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:nextMoment.createdAt];

    moment.authorAvatar = [imageCache imageFromMemoryCacheForKey:nextMoment.user.avatar.thumb.absoluteString];
    if (!moment.authorAvatar) {
        NSData *imageData = [NSData dataWithContentsOfURL:nextMoment.user.avatar.thumb];
        moment.authorAvatar = [UIImage imageWithData:imageData];
    }

    moment.media = [imageCache imageFromMemoryCacheForKey:nextMoment.media.large.absoluteString];
    if (!moment.media) {
        NSData *imageData = [NSData dataWithContentsOfURL:nextMoment.media.large];
        moment.media = [UIImage imageWithData:imageData];
    }

    moment.blurredBackground = [[moment.media imageScaledToFitSize:CGSizeMake(300, 300)] blurredImage];
    self.randomizedMomentsData[@(index)] = moment;
    NSLog(@"Moment %i prepared", index);
}

- (void)displayNextMoment
{
    [self displayMomentAtIndex:self.nextMomentIndex];

    self.nextMomentIndex++;
    if (self.nextMomentIndex >= self.randomizedMomentsInfo.count) {
        self.nextMomentIndex = 0;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_TARGET_QUEUE_DEFAULT, 0), ^{
        [self prepareNextMoment];
    });
}

- (void)displayMomentAtIndex:(NSUInteger)index
{
    if (!self.randomizedMomentsData[@(index)]) {
        [self prepareMomentAtIndex:index];
    }

    Moment *moment = self.randomizedMomentsData[@(index)];
    if ([self.slideshowDisplayDelegate respondsToSelector:@selector(displayMoment:duration:)]) {
        NSLog(@"Display moment %i", index);
        [self.slideshowDisplayDelegate displayMoment:moment duration:self.configuration.slideDuration];
    }

    if ([self.slideshowControlDelegate respondsToSelector:@selector(displayingMomentAtIndex:)]) {
        NSInteger displayedIndex = [self.momentsInfo indexOfObject:self.randomizedMomentsInfo[index]];
        [self.slideshowControlDelegate displayingMomentAtIndex:displayedIndex];
    }
}

@end