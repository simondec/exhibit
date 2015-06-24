//
// Created by Simon de Carufel on 15-06-24.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "LogoViewController.h"
#import "LogoView.h"

@interface LogoViewController ()
@end

@implementation LogoViewController
- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];

    LogoView *logoView = [LogoView new];
    [logoView sizeToFit];
    [self.view addSubview:logoView];

    logoView.center = self.view.center;
    logoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
}
@end