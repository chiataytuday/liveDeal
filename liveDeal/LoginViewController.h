//
//  LoginViewController.h
//  liveDeal
//
//  Created by claudio barbera on 17/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "User.h"
@protocol LoginDelegate <NSObject>

-(void)didAuthenticateWithFB:(BOOL)isFb;

@end

@interface LoginViewController : UIViewController <UITextFieldDelegate, FBLoginViewDelegate>
{
    NSMutableData *tempArray;
    MBProgressHUD *hud;
    
}


@property (nonatomic, retain) IBOutlet UITextField *txtEmail;
@property (nonatomic, retain) IBOutlet UITextField *txtPwd;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@property (nonatomic, retain) id<SelectDelegate> delegate;
-(IBAction)logon:(id)sender;

- (IBAction)performLogin:(id)sender;

@end
