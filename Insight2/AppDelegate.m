//
//  AppDelegate.m
//  Insight2
//
//  Created by Krishna Bharathala on 11/19/15.
//  Copyright © 2015 Krishna Bharathala. All rights reserved.
//

#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "MasterTableViewController.h"
#import "LoginViewController.h"
#import "SettingsTableViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AppDelegate ()

@property (nonatomic, strong) SWRevealViewController *SWRevealViewController;
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) LoginViewController *startVC;

@property (nonatomic, strong) MasterTableViewController *masterTableViewController;
@property (strong, nonatomic) SettingsTableViewController *rightViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.startVC = [[LoginViewController alloc] init];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.startVC];
    self.navController.navigationBarHidden = YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)presentSWController{
    
    self.mainVC = [[CameraViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *microphoneNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mainVC];
    
    SettingsTableViewController *settingsVC = [[SettingsTableViewController alloc] init];
    UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    
    self.masterTableViewController = [[MasterTableViewController alloc] init];
    self.masterTableViewController.cameraVC = self.mainVC;
    UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:self.masterTableViewController];
    
    self.SWRevealViewController = [[SWRevealViewController alloc] initWithRearViewController:masterNavigationController frontViewController:microphoneNavigationController];
    
    [self.SWRevealViewController setRightViewController:settingsNavController];
    
    [self.navController pushViewController:self.SWRevealViewController animated:YES];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                          openURL:url
                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

@end
