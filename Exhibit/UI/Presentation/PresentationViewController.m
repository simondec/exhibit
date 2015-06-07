//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "PresentationViewController.h"
#import "SlideshowController.h"
#import "PresentationView.h"
#import "Moment.h"

@interface PresentationViewController() <PresentationViewDelegate, SlideshowObserver>
@property (nonatomic) SlideshowController *slideshowController;
@property (nonatomic) PresentationView *presentationView;
@property (nonatomic) BOOL presentingMoment;
@property (nonatomic) Moment *pendingNextMoment;
@end

@implementation PresentationViewController
- (instancetype)initWithSlideshowController:(SlideshowController *)slideshowController
{
    if (self = [super init]) {
        _slideshowController = slideshowController;
    }
    return self;
}

- (void)loadView
{
    self.presentationView = [PresentationView new];
    self.presentationView.delegate = self;
    self.view = self.presentationView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.slideshowController addSlideshowObserver:self];
    [self.slideshowController startSlideshow];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.slideshowController removeSlideshowObserver:self];
}

//------------------------------------------------------------------------------
#pragma mark - SlideshowObserver
//------------------------------------------------------------------------------


- (void)didLoadMoments:(NSInteger)numberOfMoments
{

}

- (void)displayMoment:(Moment *)moment atChronologicalIndex:(NSInteger)index
{
    if (!self.presentingMoment) {
        self.presentingMoment = YES;
        [self.presentationView transitionToMoment:moment duration:self.slideshowController.slideDuration];
    } else {
        self.pendingNextMoment = moment;
    }
}

//------------------------------------------------------------------------------
#pragma mark - PresentationViewDelegate
//------------------------------------------------------------------------------

- (void)didCompleteTransition
{
    self.presentingMoment = NO;
    if (self.pendingNextMoment) {
        [self displayMoment:self.pendingNextMoment atChronologicalIndex:0];
        self.pendingNextMoment = nil;
    }
}
@end