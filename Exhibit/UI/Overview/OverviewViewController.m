//
// Created by Simon de Carufel on 15-06-07.
// Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "OverviewViewController.h"
#import "OverviewView.h"
#import "Settings.h"
#import <Aubergiste/AUBOrganization.h>

@interface OverviewViewController ()
@property (nonatomic, weak) Settings *settings;
@property (nonatomic) OverviewView *overviewView;
@property (nonatomic) BOOL secondaryScreenConnected;
@end

@implementation OverviewViewController

- (instancetype)initWithSettings:(Settings *)settings secondaryScreenConnected:(BOOL)connected
{
    if (self = [super init]) {
        _settings = settings;
        _secondaryScreenConnected = connected;
    }
    return self;
}
- (void)loadView
{
    self.overviewView = [OverviewView new];
    self.view = self.overviewView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.overviewView.startSlideshowButton addTarget:self action:@selector(startSlideshowButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.settings addObserver:self forKeyPath:@"organization" options:NSKeyValueObservingOptionNew context:nil];
    [self.overviewView setOrganization:self.settings.organization];
    [self.overviewView setSecondaryScreenConnected:self.secondaryScreenConnected];
    [self.overviewView startPanningBackround];
    [self registerNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
    [self.settings removeObserver:self forKeyPath:@"organization"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.overviewView setOrganization:self.settings.organization];
}

//------------------------------------------------------------------------------
#pragma mark - Public Methods
//------------------------------------------------------------------------------

- (void)setSecondaryScreenConnected:(BOOL)connected
{
    _secondaryScreenConnected = connected;
    [self.overviewView setSecondaryScreenConnected:connected];
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)unregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

//------------------------------------------------------------------------------
#pragma mark - Event Handling
//------------------------------------------------------------------------------

- (void)applicationDidBecomeActive {
    if (self.overviewView) {
        [self.overviewView startPanningBackround];
    }
}

//------------------------------------------------------------------------------
#pragma mark - Control Events
//------------------------------------------------------------------------------

- (void)startSlideshowButtonTapped
{
    if (self.delegate) {
        [self.delegate overviewViewControllerStartSlideshowButtonTapped];
    }
}
@end