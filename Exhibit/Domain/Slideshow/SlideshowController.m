//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "SlideshowController.h"
#import "Configuration.h"
#import "Moment.h"
#import "AUBMoment.h"

@interface SlideshowController ()
@property (nonatomic) Configuration *configuration;
@property (nonatomic) NSMutableArray *observers;
@property (nonatomic) NSMutableArray *momentsInfo;
@property (nonatomic) NSMutableArray *momentsData;
@property (nonatomic) NSInteger currentIndex;
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

}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)loadMoments
{
    __weak typeof(self) wSelf = self;
    [AUBMoment listFromOrganization:self.configuration.organizationID amount:100 from:nil completion:^(NSArray *array, NSError *error) {
        @synchronized (wSelf.momentsInfo) {
            wSelf.momentsInfo = [array mutableCopy];
            [wSelf shuffleMomentsInfo];
            [wSelf preloadMomentsData];
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

- (void)preloadMomentsData
{
    for (NSInteger i = 0; i < 3; i++) {

    }
}

@end