//
// Created by Simon de Carufel on 15-06-02.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "PresentationViewController.h"
#import "SlideshowController.h"

@interface PresentationViewController()
@property (nonatomic) SlideshowController *slideshowController;
@end

@implementation PresentationViewController
- (instancetype)initWithSlideshowController:(SlideshowController *)slideshowController
{
    if (self = [super init]) {
        _slideshowController = slideshowController;
    }
    return self;
}
@end