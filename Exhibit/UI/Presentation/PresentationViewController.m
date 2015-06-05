//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "PresentationViewController.h"
#import "SlideshowController.h"
#import "PresentationView.h"
#import "Moment.h"

@interface PresentationViewController() <SlideshowDisplay>
@property (nonatomic) SlideshowController *slideshowController;
@property (nonatomic) PresentationView *presentationView;
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
    self.view = self.presentationView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.slideshowController setSlideshowDisplayDelegate:self];
    [self.slideshowController startSlideshow];
}

//------------------------------------------------------------------------------
#pragma mark - SlideshowObserver
//------------------------------------------------------------------------------

- (void)displayMoment:(Moment *)moment duration:(NSTimeInterval)duration
{
    [self.presentationView transitionToMoment:moment duration:duration];
}
@end