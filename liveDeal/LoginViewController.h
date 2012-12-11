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

@protocol LoginDelegate <NSObject>

-(void)didAuthenticateWithFB:(BOOL)isFb;

@end

@interface LoginViewController : UIViewController <UITextFieldDelegate, FBLoginViewDelegate>
{
    NSMutableData *tempArray;
    MBProgressHUD *hud;
    
}


@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UITextField *txtEmail;
@property (nonatomic, retain) IBOutlet UITextField *txtPwd;
@property (nonatomic, retain) IBOutlet UIImageView *imgViewLogFB;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@property (nonatomic,retain) id<LoginDelegate> delegate;

-(IBAction)logon:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)performLogin:(id)sender;

@end
