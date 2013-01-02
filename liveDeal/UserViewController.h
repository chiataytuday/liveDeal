//
//  UserViewController.h
//  liveDeal
//
//  Created by claudio barbera on 01/01/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "User.h"
#import "UserDetailViewController.h"
#import "DealsAcquistatiViewController.h"
#import "LoginViewController.h"
#import "Utility.h"

@interface UserViewController : UITableViewController <UITableViewDelegate, SelectDelegate, LoginDelegate>
{
    MBProgressHUD *hud;
    NSMutableData *tempArray;

}

@property (nonatomic, retain) LoginViewController *loginController;
@property (nonatomic, retain) User *user;



@end
