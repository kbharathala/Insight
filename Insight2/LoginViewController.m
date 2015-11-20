//
//  StartViewController.m
//  Insight2
//
//  Created by Krishna Bharathala on 11/19/15.
//  Copyright © 2015 Krishna Bharathala. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *logoButton=[UIButton buttonWithType:UIButtonTypeCustom];
    logoButton.frame=CGRectMake(0,0,self.view.frame.size.width,180);
    [logoButton setImage:[UIImage imageNamed:@"insight.jpg"] forState:UIControlStateNormal];
    logoButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [logoButton setUserInteractionEnabled:NO];
    [self.view addSubview:logoButton];
    
    UIView *fillView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2+90, self.view.frame.size.width, 200)];
    fillView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:fillView];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"false" forKey:@"people"];
    [defaults setObject:@"false" forKey:@"places"];
    [defaults setObject:@"false" forKey:@"events"];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:gr];
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_events", @"user_friends", @"user_posts"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"Process error");
                                } else if (result.isCancelled) {
                                    NSLog(@"Cancelled");
                                } else {
                                    NSString *fbAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                                    NSLog(@"%@", fbAccessToken);
                                    
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    [defaults setObject:fbAccessToken forKey:@"fbAuth"];
                                    
                                    [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentSWController];
                                }
                            }];
    
}

@end
