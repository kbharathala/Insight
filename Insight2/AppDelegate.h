//
//  AppDelegate.h
//  Insight2
//
//  Created by Krishna Bharathala on 11/19/15.
//  Copyright © 2015 Krishna Bharathala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CameraViewController *mainVC;

-(void)presentSWController;

@end

