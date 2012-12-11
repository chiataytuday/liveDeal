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

@interface UserViewController : UIViewController <LoginDelegate>
{
    MBProgressHUD *hud;
    NSMutableData *tempArray;
}

@property (nonatomic, retain) IBOutlet UILabel *lbl;
@property (nonatomic, retain) IBOutlet UIButton *btnLogin;
@property (nonatomic, retain) IBOutlet UIButton *btnLogout;
@property (nonatomic, retain) IBOutlet UIButton *btnRegistrati;
@property (nonatomic, retain) IBOutlet UIView *mainView;


-(IBAction)logout:(id)sender;
-(IBAction)goToLogin:(id)sender;

@end
