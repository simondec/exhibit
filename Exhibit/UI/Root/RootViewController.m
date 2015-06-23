//
// Created by Simon de Carufel on 15-06-19.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "RootViewController.h"
#import "Settings.h"
#import "SettingsViewController.h"
#import "OverviewViewController.h"
#import "RootView.h"

@interface RootViewController () <OverviewViewControllerDelegate>
@property (nonatomic) SettingsViewController *settingsViewController;
@property (nonatomic) UINavigationController *settingsNavigationController;
@property (nonatomic) OverviewViewController *overviewViewController;
@property (nonatomic) RootView *rootView;
@end

@implementation RootViewController
- (instancetype)initWithSettings:(Settings *)settings secondaryScreenConnected:(BOOL)connected
{
    if (self = [super init]) {
        self.settingsViewController = [[SettingsViewController alloc] initWithLayoutFileName:@"settings" settings:settings];
        self.settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:self.settingsViewController];
        [self addChildViewController:self.settingsNavigationController];

        self.overviewViewController = [[OverviewViewController alloc] initWithSettings:settings secondaryScreenConnected:connected];
        self.overviewViewController.delegate = self;
        [self addChildViewController:self.overviewViewController];
    }
    return self;
}

- (void)loadView
{
    self.rootView = [RootView new];
    self.rootView.leftPaneView = self.settingsNavigationController.view;
    self.rootView.rightPaneView = self.overviewViewController.view;
    self.view = self.rootView;
}

- (void)viewDidLayoutSubviews
{
    [self.rootView preparePanelsForDisplay];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.rootView displayPanels];
}

- (void)setSecondaryScreenConnected:(BOOL)connected
{
    [self.overviewViewController setSecondaryScreenConnected:connected];
}

//------------------------------------------------------------------------------
#pragma mark - OverviewViewControllerDelegate
//------------------------------------------------------------------------------

- (void)overviewViewControllerStartSlideshowButtonTapped
{
    [self.rootView hidePanels:^{
        if (self.delegate) {
            [self.delegate rootViewControllerStartSlideshowButtonTapped];
        }
    }];
}

@end