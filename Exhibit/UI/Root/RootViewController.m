//
// Created by Simon de Carufel on 15-06-19.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "RootViewController.h"
#import "Settings.h"
#import "SettingsViewController.h"
#import "OverviewViewController.h"
#import "RootView.h"

@interface RootViewController () <OverviewViewControllerDelegate, SettingsViewControllerDelegate>
@property (nonatomic) SettingsViewController *settingsViewController;
@property (nonatomic) UINavigationController *settingsNavigationController;
@property (nonatomic) OverviewViewController *overviewViewController;
@property (nonatomic) UIUserInterfaceIdiom userInterfaceIdiom;
@property (nonatomic) BOOL secondaryScreenDetected;
@property (nonatomic) RootView *rootView;
@end

@implementation RootViewController
- (instancetype)initWithSettings:(Settings *)settings secondaryScreenConnected:(BOOL)connected
{
    if (self = [super init]) {
        self.userInterfaceIdiom = [UIScreen mainScreen].traitCollection.userInterfaceIdiom;
        self.settingsViewController = [[SettingsViewController alloc] initWithLayoutFileName:@"settings" settings:settings];
        self.settingsViewController.delegate = self;
        self.settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:self.settingsViewController];
        [self addChildViewController:self.settingsNavigationController];

        self.overviewViewController = [[OverviewViewController alloc] initWithSettings:settings secondaryScreenConnected:connected];
        self.overviewViewController.delegate = self;
        [self addChildViewController:self.overviewViewController];
    }
    return self;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UITraitCollection *traitCollection = [UIScreen mainScreen].traitCollection;
    if (traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)loadView
{
    UITraitCollection *traitCollection = [UIScreen mainScreen].traitCollection;
    self.rootView = [[RootView alloc] initWithUserInterfaceIdiom:self.userInterfaceIdiom];
    self.rootView.rightPanelView = self.overviewViewController.view;
    self.rootView.leftPanelView = self.settingsNavigationController.view;
    self.view = self.rootView;
}

- (void)viewDidLayoutSubviews
{
    [self.rootView preparePanelsForDisplay];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.rootView displayRightPanelWithDelay:1.0f];
    if (self.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [self.rootView displayLeftPanelWithDelay:0.5f];
    } else {
        [self.overviewViewController setConfigureButtonVisible:YES];
        [self.overviewViewController setSecondaryScreenRequired:YES];
        [self.settingsViewController setCloseButtonVisible:YES];
    }
}

- (void)setSecondaryScreenConnected:(BOOL)connected
{
    _secondaryScreenDetected = connected;
    [self.overviewViewController setSecondaryScreenConnected:connected];
}

//------------------------------------------------------------------------------
#pragma mark - OverviewViewControllerDelegate
//------------------------------------------------------------------------------

- (void)overviewViewControllerStartSlideshowButtonTapped
{

    [self.rootView hideRightPanel:^{
        [self.rootView hideLeftPanel:^{
            if (self.delegate) {
                [self.delegate startSlideshowWithSettings:self.settingsViewController.settings];
            }
        }];
    }];

}

- (void)overviewViewControllerConfigureButtonTapped
{
    [self.rootView displayLeftPanelWithDelay:0];
}

//------------------------------------------------------------------------------
#pragma mark - SettingsViewControllerDelegate
//------------------------------------------------------------------------------

- (void)settingsViewControllerCloseButtonTapped
{
    [self.rootView hideLeftPanel:nil];
}

@end