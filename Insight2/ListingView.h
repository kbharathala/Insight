//
//  ListingView.h
//  TagViewTest
//
//  Created by Krishna Bharathala on 11/19/15.
//  Copyright © 2015 Krishna Bharathala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"

@interface ListingView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *property;
@property (nonatomic, strong) NSString *value;
@property (nonatomic) BOOL flipped;
@property (nonatomic, strong) NSString *review;
@property (nonatomic, strong) NSString *type;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) float heading;
@property (nonatomic) float distance;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *url;
@property (nonatomic, strong) CameraViewController *viewCon;
@property (nonatomic) float quartile;

@end
