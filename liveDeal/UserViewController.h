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

@interface UserViewController : UITableViewController <UITableViewDelegate, SelectDelegate>
{
    MBProgressHUD *hud;
    NSMutableData *tempArray;
}

@property (nonatomic, retain) IBOutlet UILabel *lblInt;




@end
