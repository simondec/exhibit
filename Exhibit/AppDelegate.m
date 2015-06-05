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
#import "Configuration.h"
#import "MomentsViewController.h"

static NSString *const AubergisteClientID = @"893123332c62670ee75b90df3e6378d2cefc85ac84d3e07d63ae37291414bef0";
static NSString *const AubergisteClientSecret = @"1e443d57507880fe32853ddf242e13762e17843300e87f3ce25eb8c6e434cb61";

@interface AppDelegate ()
@property (nonatomic) SlideshowController *slideshowController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AUBAubergiste sharedInstance] setClientID:AubergisteClientID clientSecret:AubergisteClientSecret];
    
    [application setStatusBarHidden:YES];

    Configuration *config = [Configuration new];
    config.organizationID = @"mirego";
    config.slideDuration = 8;
    config.slideCount = 50;

    self.slideshowController = [[SlideshowController alloc] initWithConfiguration:config];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];

//    PresentationViewController *presentationViewController = [[PresentationViewController alloc] initWithSlideshowController:self.slideshowController];
//    self.window.rootViewController = presentationViewController;

    MomentsViewController *momentsViewController = [[MomentsViewController alloc] initWithSlideshowController:self.slideshowController];
    self.window.rootViewController = momentsViewController;

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskLandscape;
}

@end
