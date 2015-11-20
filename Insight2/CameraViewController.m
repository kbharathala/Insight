//
//  ViewController.m
//  Insight2
//
//  Created by Krishna Bharathala on 11/19/15.
//  Copyright © 2015 Krishna Bharathala. All rights reserved.
//

#import "CameraViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "ListingView.h"
#import "SVProgressHUD.h"
#import "ListingView.h"
#import <MapKit/MapKit.h>

#import <AVFoundation/AVFoundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface CameraViewController ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOuput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) int loops;
@property (nonatomic) int heading;

@property (nonatomic, strong) NSMutableArray *listingArray;
@property (nonatomic, strong) NSMutableArray *listingArray2;

@property (nonatomic) BOOL gettingData;
@property (nonatomic) BOOL gotData;
@property (nonatomic) BOOL didInit;

@property (nonatomic) float previousY;
@property (nonatomic) float previousX;

@property (nonatomic) int size;

@end

@implementation CameraViewController

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor =[UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if([self.captureSession canAddInput:deviceInput]) {
        [self.captureSession addInput:deviceInput];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [self.view layer];
    [rootLayer setMasksToBounds:YES];
    
    [self.previewLayer setFrame:self.view.bounds];
    [rootLayer insertSublayer:self.previewLayer atIndex:0];
    
    AVCaptureConnection *previewLayerConnection=self.previewLayer.connection;
    
    if ([previewLayerConnection isVideoOrientationSupported])
        [previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    
    self.stillImageOuput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOuput setOutputSettings:outputSettings];
    
    [self.captureSession addOutput: self.stillImageOuput];
    [self.captureSession startRunning];
    
    self.size = 40;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:revealController
                                                                        action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *revealRightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear.png"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:revealController
                                                                             action:@selector(rightRevealToggle:)];
    self.navigationItem.rightBarButtonItem = revealRightButtonItem;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
    
    self.gettingData = NO;
    self.gotData = NO;
    self.didInit = NO;
    
    self.listingArray = [[NSMutableArray alloc] init];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if(self.loops == 3) {
        float latitude = self.locationManager.location.coordinate.latitude;
        float longitude = self.locationManager.location.coordinate.longitude;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat: @"%f", latitude] forKey:@"latitude"];
        [defaults setObject:[NSString stringWithFormat: @"%f", longitude] forKey:@"longitude"];
        
        NSLog(@"%f, %f", latitude, longitude);
    }
    self.loops++;
}

-(void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    self.heading = (int) newHeading.trueHeading;
    NSLog(@"%d", self.heading);
    self.previousX = 1000;
    self.previousY = 1000;
    if(!self.gettingData && self.gotData) {
        for(ListingView *l in self.listingArray) {
            float xval = ((l.heading - self.heading)/60 + 1/2)*self.view.frame.size.width;
            float yval = l.quartile*(self.view.frame.size.height-80)+40;
            if(yval > self.previousY-self.size) {
                if(xval < self.previousX+self.size*6 && xval+self.size*6 > self.previousX) {
                    yval = self.previousY - self.size;
                }
            }
            l.center = CGPointMake(xval, yval);
            NSLog(@"%f, %f", xval, yval);
            self.previousX = xval;
            self.previousY = yval;
        }
    }
}

-(void) removeViews {
    for(ListingView *l in self.listingArray) {
        [l removeFromSuperview];
    }
}

-(void) infoButtonPressedWithObject:(id)obj {
    NSString *url = ((ListingView *)obj).url;
    if(url) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: ((ListingView *)obj).url]];
    } else {
        [SVProgressHUD showErrorWithStatus:@"No Website Available"];
    }
}

-(void) reviewsButtonPressedWithObject:(id)obj {
    NSString *url = ((ListingView *)obj).review;
    if(url) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: ((ListingView *)obj).review]];
    } else {
        [SVProgressHUD showErrorWithStatus:@"No Reviews Available"];
    }
}

-(void) directionsButtonPressedWithObject:(id)obj {
    ListingView *l = (ListingView *)obj;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(l.latitude, l.longitude);
    MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: coordinate addressDictionary: nil];
    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
    destination.name = l.title;
    NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             MKLaunchOptionsDirectionsModeDriving,
                             MKLaunchOptionsDirectionsModeKey, nil];
    [MKMapItem openMapsWithItems: items launchOptions: options];
    
}

-(void) checkinButtonPressedWithObject:(id)obj {
    NSLog(@"Checkin Button Pressed");
    
    ListingView *l = obj;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    if (![[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        [login logInWithPublishPermissions:@[@"publish_actions"]
                        fromViewController:(UIViewController *)self.previewLayer
                                   handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                       self.fbAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                                       [self.userDefaults setObject:self.fbAccessToken forKey:@"fbAuth"]; }];
    }

    NSString *post = [NSString stringWithFormat:@"authToken=%@&latitude=%f&longitude=%f&name=%@",
                                                [self.userDefaults objectForKey:@"fbAuth"],
                                                l.latitude, l.longitude, [l.title stringByReplacingOccurrencesOfString:@" " withString: @"+"]];
    NSLog(@"%@", post);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:@"https://insight-fb-global.herokuapp.com/fb_checkin"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSDictionary *loginSuccessful = [NSJSONSerialization JSONObjectWithData:data
                                                                                                          options:kNilOptions
                                                                                                            error:&error];
                                          NSLog(@"%@", loginSuccessful);
                                          if([loginSuccessful objectForKey:@"id"]) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [SVProgressHUD showSuccessWithStatus:@"Checked In!"];
                                              });
                                          }
                                      }];
    [dataTask resume];
}

-(void) peoplesPressed {
    self.gotData = NO;
    [self removeViews];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [[self.userDefaults objectForKey:@"people"] isEqualToString:@"true"] ? [self.userDefaults setObject:@"false" forKey:@"people"] :
                                                                           [self.userDefaults setObject:@"true" forKey:@"people"];
    [self runRequest];
}

-(void) placesPressed {
    self.gotData = NO;
    [self removeViews];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [[self.userDefaults objectForKey:@"places"] isEqualToString:@"true"] ? [self.userDefaults setObject:@"false" forKey:@"places"] :
                                                                           [self.userDefaults setObject:@"true" forKey:@"places"];
    [self runRequest];
}

-(void) eventsPressed {
    self.gotData = NO;
    [self removeViews];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [[self.userDefaults objectForKey:@"events"] isEqualToString:@"true"] ? [self.userDefaults setObject:@"false" forKey:@"events"] :
                                                                           [self.userDefaults setObject:@"true" forKey:@"events"];
    [self runRequest];

}

-(void) runRequest {
    
    self.gettingData = YES;
    
    NSString *radius;
    NSString *category;
    
    if([self.userDefaults objectForKey:@"radius"]) {
        radius = [self.userDefaults objectForKey:@"radius"];
    } else {
        radius = @"2000";
    }
    
    if([self.userDefaults objectForKey:@"category"]) {
        category = [self.userDefaults objectForKey:@"category"];
    } else {
        category = @"restaurant";
    }
    
    NSString *post = [NSString stringWithFormat: @"latitude=%@&longitude=%@&authToken=%@&people=%@&places=%@&events=%@radius=%@",
                      [self.userDefaults objectForKey:@"latitude"],
                      [self.userDefaults objectForKey:@"longitude"],
                      [self.userDefaults objectForKey:@"fbAuth"],
                      [self.userDefaults objectForKey:@"people"],
                      [self.userDefaults objectForKey:@"places"],
                      [self.userDefaults objectForKey:@"events"],
                      radius];
    
    NSLog(@"%@", post);
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:@"https://insight-fb-global.herokuapp.com/insight"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [SVProgressHUD show];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSURLSession *session = [NSURLSession sharedSession];
        __weak CameraViewController* weak_self = self;
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                              NSDictionary *loginSuccessful = [NSJSONSerialization JSONObjectWithData:data
                                                                                                              options:kNilOptions
                                                                                                                error:nil];
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  weak_self.listingArray = [[NSMutableArray alloc] init];
                                                  for(NSDictionary *dict in loginSuccessful) {
                                                      NSLog(@"%@", dict);
                                                      float xval = (([[dict objectForKey:@"heading"] floatValue] - weak_self.heading)/60 + 1/2)*self.view.frame.size.width;
                                                      float yval = [[dict objectForKey:@"distance"] floatValue]/2000 * weak_self.view.frame.size.width;
                                                      
                                                      ListingView *tempListing = [[ListingView alloc] initWithFrame:CGRectMake(xval, yval, self.size*6, self.size)];
                                                      tempListing.title = [dict objectForKey:@"name"];
                                                      tempListing.property = @"Distance";
                                                      tempListing.value = [dict objectForKey:@"distance"];
                                                      tempListing.flipped = NO;
                                                      tempListing.latitude = [[[dict objectForKey:@"location"] objectForKey:@"latitude"] floatValue];
                                                      tempListing.longitude = [[[dict objectForKey:@"location"] objectForKey:@"longitude"] floatValue];
                                                      tempListing.heading = [[dict objectForKey:@"heading"] floatValue];
                                                      tempListing.distance = [[dict objectForKey:@"distance"] floatValue];
                                                      tempListing.url = [dict objectForKey:@"website"];
                                                      tempListing.review = [dict objectForKey:@"yelp_review_link"];
                                                      tempListing.viewCon = self;
                                                      tempListing.type = [dict objectForKey:@"type"];
                                                      tempListing.quartile = [[[dict objectForKey:@"quartiles"] objectForKey:@"height"] floatValue];
                                                      
                                                      tempListing.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.5];
                                                      
                                                      [weak_self.view addSubview:tempListing];
                                                      [weak_self.listingArray addObject:tempListing];
                                                  }
                                                  NSLog(@"%@", weak_self.listingArray);
                                                  [SVProgressHUD dismiss];
                                              });
                                              weak_self.gettingData = NO;
                                              weak_self.gotData = YES;
                                          }];
            [dataTask resume];
    });
}

@end
