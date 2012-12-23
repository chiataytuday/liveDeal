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

@interface UserViewController : UITableViewController <UITableViewDelegate>
{
    MBProgressHUD *hud;
    NSMutableData *tempArray;
}

@property (nonatomic, retain) IBOutlet UILabel *lbl;




@end
