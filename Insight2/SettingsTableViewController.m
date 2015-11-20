//
//  SettingsTableViewController.m
//  PickUp
//
//  Created by Krishna Bharathala on 9/4/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "LoginViewController.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SettingsTableViewController ()

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *changedPass;
@property (nonatomic, strong) NSString *alertMessage;

@end

@implementation SettingsTableViewController

-(id) init {
    self = [super init];
    if(self) {
        self.title = @"Settings";
    }
    return self;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.title = @"";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.bounces = NO;
    
    self.alertMessage = @"";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCell" forIndexPath:indexPath];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Set Radius";
            break;
        
        case 1:
            cell.textLabel.text = @"Set Category";
            break;
            
        case 2:
            cell.textLabel.text = @"Contact Us";
            break;
            
        case 3:
            cell.textLabel.text = @"Logout";
            break;
        
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            [self updateRadius];
            break;
            
        case 1:
            [self updateCategory];
            break;
            
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:kbharathala@gmail.com"]];
            break;
            
        case 3:
            [self logOut];
            break;
    }
}

- (void) logOut {
    NSLog(@"Logging out");
    [[FBSDKLoginManager new] logOut];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

-(void) updateRadius {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Change Radius"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:nil];
    alert.textFields[0].keyboardType = UIKeyboardTypeNumberPad;
    UIAlertAction* setAction = [UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //NSLog(@"%@", alert.textFields[0].text);
                                                              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                              [defaults setObject:alert.textFields[0].text forKey:@"radius"];
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * action) {}];
    
    [alert addAction:cancelAction];
    [alert addAction:setAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) updateCategory {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Change Category"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:nil];
    UIAlertAction* setAction = [UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          //NSLog(@"%@", alert.textFields[0].text);
                                                          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                          [defaults setObject:alert.textFields[0].text forKey:@"category"];
                                                      }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    
    [alert addAction:cancelAction];
    [alert addAction:setAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
