//
//  AppDelegate.m
//  Exhibit
//
//  Created by Simon de Carufel on 2015-06-02.
//  Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import <MCUIViewLayout/UIView+MCLayout.h>
#import "AppDelegate.h"
#import "AUBAubergiste.h"
#import "PresentationViewController.h"
#import "SlideshowController.h"
#import "Settings.h"
#import "MomentsViewController.h"
#import "SettingsViewController.h"
#import "OverviewViewController.h"
#import "RootViewController.h"
#import "StorageClient.h"
#import "LogoViewController.h"
#import <Keys/ExhibitKeys.h>

@interface AppDelegate () <RootViewControllerDelegate>
@property (nonatomic) SlideshowController *slideshowController;
@property (nonatomic) RootViewController *rootViewController;
@property (nonatomic) PresentationViewController *presentationViewController;
@property (nonatomic) UIWindow *externalWindow;
@property (nonatomic) BOOL hasStartedSlideshow;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ExhibitKeys *keys = [[ExhibitKeys alloc] init];
    
    [[AUBAubergiste sharedInstance] setClientID:keys.aubergisteClientID clientSecret:keys.aubergisteClientSecret];
    
    [application setStatusBarHidden:YES];

    Settings *config = [StorageClient objectForKey:StorageSettingsKey];
    if (!config) {
        config = [Settings new];
        config.slideDuration = 7;
        config.slideCount = 52;
        config.recentMomentsLookupInterval = 60 * 30;
        config.remoteEnabled = YES;
    }

    self.slideshowController = [[SlideshowController alloc] initWithConfiguration:config];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];

    [self checkForExistingScreenAndInitializeIfPresent];

    self.rootViewController = [[RootViewController alloc] initWithSettings:config secondaryScreenConnected:(self.externalWindow != nil)];
    self.rootViewController.delegate = self;

    self.window.rootViewController = self.rootViewController;

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleScreenDidConnectNotification:) name:UIScreenDidConnectNotification object:nil];
    [center addObserver:self selector:@selector(handleScreenDidDisconnectNotification:) name:UIScreenDidDisconnectNotification object:nil];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)_window {
    if ([UIScreen mainScreen] == _window.screen || !_window) {
        return UIInterfaceOrientationMaskAll;
    }else {
        return UIInterfaceOrientationPortrait;
    }
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

- (void)checkForExistingScreenAndInitializeIfPresent
{
    if ([[UIScreen screens] count] > 1)
    {
        // Get the screen object that represents the external display.
        UIScreen *secondScreen = [[UIScreen screens] objectAtIndex:1];
        // Get the screen's bounds so that you can create a window of the correct size.
        CGRect screenBounds = secondScreen.bounds;

        self.externalWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        self.externalWindow.backgroundColor = [UIColor blackColor];
        self.externalWindow.screen = secondScreen;
        self.externalWindow.hidden = NO;
        self.externalWindow.rootViewController = [LogoViewController new];

        NSLog(@"External window detected");

    }
}

- (void)launchSlideshowWithSettings:(Settings *)settings
{

    [StorageClient putObject:settings forKey:StorageSettingsKey];

    self.presentationViewController = [[PresentationViewController alloc] initWithSlideshowController:self.slideshowController settings:settings];

    if (self.externalWindow) {
        self.externalWindow.rootViewController = self.presentationViewController;

        if (settings.remoteEnabled) {
            MomentsViewController *momentsViewController = [[MomentsViewController alloc] initWithSlideshowController:self.slideshowController];
            self.window.rootViewController = momentsViewController;
        } else {
            self.window.rootViewController = nil;
        }


    } else {
        self.window.rootViewController = self.presentationViewController;
    }

}

//------------------------------------------------------------------------------
#pragma mark - RootViewControllerDelegateDelegate
//------------------------------------------------------------------------------

- (void)startSlideshowWithSettings:(Settings *)settings
{
    self.hasStartedSlideshow = YES;
    [self launchSlideshowWithSettings:settings];
}


//------------------------------------------------------------------------------
#pragma mark - Notification Handlers
//------------------------------------------------------------------------------

- (void)handleScreenDidConnectNotification:(NSNotification*)aNotification
{
    UIScreen *newScreen = [aNotification object];
    CGRect screenBounds = newScreen.bounds;

    if (!self.externalWindow)
    {
        self.externalWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        self.externalWindow.backgroundColor = [UIColor blackColor];
        self.externalWindow.screen = newScreen;
        self.externalWindow.hidden = NO;

        if (self.hasStartedSlideshow) {

            Settings *config = [StorageClient objectForKey:StorageSettingsKey];
            if (config.remoteEnabled) {
                MomentsViewController *momentsViewController = [[MomentsViewController alloc] initWithSlideshowController:self.slideshowController];
                self.window.rootViewController = momentsViewController;
            } else {
                self.window.rootViewController = nil;
            }

            self.externalWindow.rootViewController = self.presentationViewController;
        } else {
            self.externalWindow.rootViewController = [LogoViewController new];
            [self.rootViewController setSecondaryScreenConnected:YES];
        }
    }

    NSLog(@"External window connected");
}

- (void)handleScreenDidDisconnectNotification:(NSNotification*)aNotification
{
    if (self.externalWindow)
    {
        self.externalWindow.rootViewController = nil;
        self.externalWindow.hidden = YES;
        self.externalWindow = nil;

        if (self.hasStartedSlideshow) {
            self.window.rootViewController = self.presentationViewController;
        } else {
            [self.rootViewController setSecondaryScreenConnected:NO];
        }
    }

    NSLog(@"External window disconnected");
}


@end
