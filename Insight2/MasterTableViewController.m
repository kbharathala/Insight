//
//  MasterTableViewController.m
//  Anypic
//
//  Created by Krishna Bharathala on 9/4/15.
//
//

#import "MasterTableViewController.h"
#import "SWRevealViewController.h"

#import "AppDelegate.h"

@interface MasterTableViewController () 

typedef NS_ENUM (NSUInteger, MasterTableViewRowType) {
    MasterTableViewRowTypePeople,
    MasterTableViewRowTypePlace,
    MasterTableViewRowTypeEvent,
    MasterTableViewRowTypeCount,
};

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *imageArray_blue;
@property (nonatomic) NSInteger currRow;

@end

@implementation MasterTableViewController

@synthesize rearTableView = _rearTableView;

-(void) viewWillAppear:(BOOL)animated {
    
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self.tableView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated {
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.title = @"";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tableView.bounces = NO;
    self.imageArray = @[@"people.png", @"places.png", @"events.png"];
    self.imageArray_blue = @[@"people_blue.png", @"places_blue.png", @"events_blue.png"];
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MasterTableViewRowTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == MasterTableViewRowTypePeople) {
        UIImageView *imageView = [[UIImageView alloc] init];
        if([[defaults objectForKey:@"people"] isEqualToString:@"true"]) {
            [imageView setImage:[UIImage imageNamed:[self.imageArray_blue objectAtIndex:indexPath.row]]];
        } else {
            [imageView setImage:[UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]]];
        }
        [cell.contentView addSubview:imageView];
        [imageView setFrame:CGRectMake(20, 20, 40, 40)];
    }
    
    if (indexPath.row == MasterTableViewRowTypePlace) {
        UIImageView *imageView = [[UIImageView alloc] init];
        if([[defaults objectForKey:@"places"] isEqualToString:@"true"]) {
            [imageView setImage:[UIImage imageNamed:[self.imageArray_blue objectAtIndex:indexPath.row]]];
        } else {
            [imageView setImage:[UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]]];
        }
        [cell.contentView addSubview:imageView];
        [imageView setFrame:CGRectMake(20, 20, 40, 40)];
    }
    
    if (indexPath.row == MasterTableViewRowTypeEvent) {
        UIImageView *imageView = [[UIImageView alloc] init];
        if([[defaults objectForKey:@"events"] isEqualToString:@"true"]) {
            [imageView setImage:[UIImage imageNamed:[self.imageArray_blue objectAtIndex:indexPath.row]]];
        } else {
            [imageView setImage:[UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]]];
        }
        [cell.contentView addSubview:imageView];
        [imageView setFrame:CGRectMake(20, 20, 40, 40)];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = self.revealViewController;
    
    if (indexPath.row == MasterTableViewRowTypePeople) {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        [self.cameraVC peoplesPressed];
    }
    
    if (indexPath.row == MasterTableViewRowTypePlace) {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        [self.cameraVC placesPressed];
    }
    
    if (indexPath.row == MasterTableViewRowTypeEvent) {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        [self.cameraVC eventsPressed];
    }
}

@end
