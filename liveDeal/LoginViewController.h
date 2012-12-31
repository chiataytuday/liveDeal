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
#import "NSString+UrlEncode.h"

#define LOGIN 0
#define FORGOT_PASSWORD 1

@protocol LoginDelegate <NSObject>

-(void)didAuthenticateWithFB:(BOOL)isFb;

@end

@interface LoginViewController : UIViewController <UITextFieldDelegate, FBLoginViewDelegate, UIAlertViewDelegate>
{
    NSMutableData *tempArray;
    MBProgressHUD *hud;
    int tipoRichiesta;
}


@property (nonatomic, retain) IBOutlet UITextField *txtEmail;
@property (nonatomic, retain) IBOutlet UITextField *txtPwd;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@property (nonatomic, retain) id<SelectDelegate> delegate;


-(IBAction)logon:(id)sender;

- (IBAction)performLogin:(id)sender;
-(IBAction)richiediPassword:(id)sender;
@end
