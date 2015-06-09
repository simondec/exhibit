//
// Created by Simon de Carufel on 15-06-07.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "OverviewViewController.h"

@interface OverviewViewController ()
@end

@implementation OverviewViewController
- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    UILabel *testLabel = [UILabel new];
    testLabel.textColor = [UIColor whiteColor];
    testLabel.text = @"Test";
    [testLabel sizeToFit];
    [self.view addSubview:testLabel];
    testLabel.center = self.view.center;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [UIView animateWithDuration:0.5f delay:1 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
//        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAutomatic;
//    } completion:nil];

}
@end