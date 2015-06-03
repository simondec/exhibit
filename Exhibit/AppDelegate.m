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

#ifdef DEBUG
static NSString *const AubergisteClientID = @"ae5a71cff0d71601c3b25e022b9b15b253587149518f32e0452d1acb6efa3a87";
static NSString *const AubergisteClientSecret = @"aa7720f9bb33ed599a72c485fbd3d60e91abdcc8af313b045e8ddf08bee0f83e";
#else
static NSString *const AubergisteClientID = @"893123332c62670ee75b90df3e6378d2cefc85ac84d3e07d63ae37291414bef0";
static NSString *const AubergisteClientSecret = @"1e443d57507880fe32853ddf242e13762e17843300e87f3ce25eb8c6e434cb61";
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AUBAubergiste sharedInstance] setClientID:AubergisteClientID clientSecret:AubergisteClientSecret];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    PresentationViewController *presentationViewController = [[PresentationViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:presentationViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
