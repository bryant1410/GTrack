//
//  AppDelegate.m
//  GTrack
//
//  Created by Michael Amaral on 1/23/15.
//  Copyright (c) 2015 Michael Amaral. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoAViewController.h"
#import "GTTracker.h"

static NSString * const YOUR_TRACKING_ID = @"UA-59392956-1";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    GTTracker *tracker = [GTTracker sharedInstance];
    [tracker initializeAnalyticsWithTrackingID:YOUR_TRACKING_ID logLevel:kGAILogLevelInfo];
    [tracker setLoggingEnabled:YES];
    [tracker setAutomaticSessionManagementEnabled:NO];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[DemoAViewController new]];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
