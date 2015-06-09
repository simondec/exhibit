//
//  AppDelegate.m
//  Exhibit
//
//  Created by Simon de Carufel on 2015-06-02.
//  Copyright (c) 2015 Simon de Carufel. All rights reserved.
//

#import "AppDelegate.h"
#import "AUBAubergiste.h"
#import "PresentationViewController.h"
#import "SlideshowController.h"
#import "Settings.h"
#import "MomentsViewController.h"
#import "SettingsViewController.h"
#import "OverviewViewController.h"

static NSString *const AubergisteClientID = @"893123332c62670ee75b90df3e6378d2cefc85ac84d3e07d63ae37291414bef0";
static NSString *const AubergisteClientSecret = @"1e443d57507880fe32853ddf242e13762e17843300e87f3ce25eb8c6e434cb61";

@interface AppDelegate ()
@property (nonatomic) SlideshowController *slideshowController;
@property (nonatomic) PresentationViewController *presentationViewController;
@property (nonatomic) UIWindow *externalWindow;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AUBAubergiste sharedInstance] setClientID:AubergisteClientID clientSecret:AubergisteClientSecret];
    
    [application setStatusBarHidden:YES];

    Settings *config = [Settings new];
    config.organizationID = @"mirego";
    config.slideDuration = 7;
    config.slideCount = 50;
    config.recentMomentsLookupInterval = 60 * 5;

    self.slideshowController = [[SlideshowController alloc] initWithConfiguration:config];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];


    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithLayoutFileName:@"settings" settings:config];
    UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];

    UISplitViewController *splitViewController = [UISplitViewController new];
    [splitViewController setViewControllers:@[settingsNavController, [OverviewViewController new]]];
    splitViewController.view.backgroundColor = [UIColor whiteColor];
//    splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
    self.window.rootViewController = splitViewController;

//    [self checkForExistingScreenAndInitializeIfPresent];
//
//    self.presentationViewController = [[PresentationViewController alloc] initWithSlideshowController:self.slideshowController];
//
//    if (self.externalWindow) {
//        self.externalWindow.rootViewController = self.presentationViewController;
//
//        MomentsViewController *momentsViewController = [[MomentsViewController alloc] initWithSlideshowController:self.slideshowController];
//        self.window.rootViewController = momentsViewController;
//
//    } else {
//        self.window.rootViewController = self.presentationViewController;
//    }
//
//
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//
//    [center addObserver:self selector:@selector(handleScreenDidConnectNotification:) name:UIScreenDidConnectNotification object:nil];
//    [center addObserver:self selector:@selector(handleScreenDidDisconnectNotification:) name:UIScreenDidDisconnectNotification object:nil];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskLandscape;
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

        NSLog(@"External window detected");

    }
}

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


        MomentsViewController *momentsViewController = [[MomentsViewController alloc] initWithSlideshowController:self.slideshowController];
        self.window.rootViewController = momentsViewController;
        self.externalWindow.rootViewController = self.presentationViewController;

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
        self.window.rootViewController = self.presentationViewController;
    }

    NSLog(@"External window disconnected");
}

@end
