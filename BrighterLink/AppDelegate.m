//
//  AppDelegate.m
//  BrighterLink
//
//  Created by mobile master on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "AppDelegate.h"
#import <BugSense-iOS/BugSenseController.h>
#import "LoginViewController.h"
#import "OAManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    ////////////////////////////////////////////////////////////////// Bug Sense Integration //////////////////////////////////////////////////////////////
    [BugSenseController sharedControllerWithBugSenseAPIKey:@"81e781fe"];
    [BugSenseController setErrorNetworkOperationsCompletionBlock:^() {
        NSLog(@"Application crashed with errorId: %ld with an error count since last reset: %d", [BugSenseController lastCrashId], [BugSenseController crashCount]);
        
        if ([BugSenseController crashCount] > 5) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"We're sorry!" message:@"We are aware of the crashes that you have experienced lately, and are actively working on fixing them for the next version!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [BugSenseController resetCrashCount];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"We're sorry!" message:@"The crash report was sent us. We will fix them quickly for the next version." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
    [[OAManager sharedInstance] setupWithSubdomain:@"brightergy"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
