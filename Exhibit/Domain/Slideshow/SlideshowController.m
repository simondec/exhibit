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
#import "UIImage+BlurredFilter.h"
#import "AUBAvatar.h"

@interface SlideshowController ()
@property (nonatomic) Configuration *configuration;
@property (nonatomic) NSMutableArray *observers;
@property (nonatomic) NSMutableArray *momentsInfo;
@property (nonatomic) NSMutableArray *momentsData;
@property (nonatomic) NSUInteger nextMomentIndex;
@property (nonatomic) NSTimer *momentSwitchTimer;
@end

@implementation SlideshowController
- (instancetype)initWithConfiguration:(Configuration *)configuration
{
    if (self = [super init]) {
        _configuration = configuration;
        _observers = [NSMutableArray new];
        _momentsInfo = [NSMutableArray new];
        _momentsData = [NSMutableArray new];
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - Public Methods
//------------------------------------------------------------------------------

- (void)addObserver:(id <SlideshowObserver>)observer
{
    [self.observers addObject:observer];
}

- (void)removeObserver:(id <SlideshowObserver>)observer
{
    [self.observers removeObject:observer];
}

- (void)startSlideshow
{
    [self loadMoments];
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)loadMoments
{
    __weak typeof(self) wSelf = self;
    [AUBMoment listFromOrganization:self.configuration.organizationID amount:10 from:nil completion:^(NSArray *array, NSError *error) {
        @synchronized (wSelf.momentsInfo) {
            wSelf.momentsInfo = [array mutableCopy];
            [wSelf shuffleMomentsInfo];
            [wSelf prepareNextMoment];
            dispatch_async(dispatch_get_main_queue(), ^{
                [wSelf displayNextMoment];
                self.momentSwitchTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(displayNextMoment) userInfo:nil repeats:YES];
            });
        }
    }];
}

- (void)shuffleMomentsInfo
{
    NSUInteger count = [self.momentsInfo count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self.momentsInfo exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

- (void)prepareNextMoment
{
    if (self.momentsData.count <= self.nextMomentIndex) {
        SDImageCache *imageCache = [SDImageCache sharedImageCache];

        AUBMoment *nextMoment = self.momentsInfo[self.nextMomentIndex];
        Moment *moment = [Moment new];
        moment.momentDescription = nextMoment.momentDescription;
        moment.author = nextMoment.user.fullName;

        moment.media = [imageCache imageFromMemoryCacheForKey:nextMoment.media.large.absoluteString];
        if (!moment.media) {
            NSData *imageData = [NSData dataWithContentsOfURL:nextMoment.media.large];
            moment.media = [UIImage imageWithData:imageData];
        }

        moment.blurredBackground = [[moment.media imageScaledToFitSize:CGSizeMake(300, 300)] blurredImage];
        [self.momentsData addObject:moment];
        NSLog(@"Moment %i prepared", self.nextMomentIndex);
    }
}

- (void)displayNextMoment
{
    Moment *moment = self.momentsData[self.nextMomentIndex++];
    for (id <SlideshowObserver> observer in self.observers) {
        if ([observer respondsToSelector:@selector(displayMoment:duration:)]) {
            NSLog(@"Display moment %i", self.nextMomentIndex - 1);
            [observer displayMoment:moment duration:5];
        }
    }

    if (self.nextMomentIndex >= self.momentsInfo.count) {
        self.nextMomentIndex = 0;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_TARGET_QUEUE_DEFAULT, 0), ^{
        [self prepareNextMoment];
    });

}

@end