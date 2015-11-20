//
//  ViewController.h
//  Insight2
//
//  Created by Krishna Bharathala on 11/19/15.
//  Copyright © 2015 Krishna Bharathala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CameraViewController : UIViewController <UINavigationControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) NSString *fbAccessToken;

-(void) infoButtonPressedWithObject:(id)obj ;
-(void) directionsButtonPressedWithObject:(id)obj;
-(void) checkinButtonPressedWithObject:(id)obj;
-(void) reviewsButtonPressedWithObject:(id)obj;

-(void) peoplesPressed;
-(void) placesPressed;
-(void) eventsPressed;

@end

