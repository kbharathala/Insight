//
//  MasterTableViewController.h
//  Anypic
//
//  Created by Krishna Bharathala on 9/4/15.
//
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"

@interface MasterTableViewController : UITableViewController

@property (nonatomic, retain) UITableView *rearTableView;
@property (nonatomic, strong) CameraViewController *cameraVC;

@end
