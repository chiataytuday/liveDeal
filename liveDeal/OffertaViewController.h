//
//  OffertaViewController.h
//  liveDeal
//
//  Created by claudio barbera on 15/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Offerta.h"
#import "UILabelStrikethrough.h"
#import "AppDelegate.h"
#import "Twitter/Twitter.h"
#import "PagamentoViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "Utility.h"
#import "LoginViewController.h"
#import "SubdealsViewController.h"
#import "Social/Social.h"
#import "AdSupport/AdSupport.h"
#import "Accounts/Accounts.h"
#import "PostToFbViewController.h"
#import "MBProgressHUD.h"

@interface OffertaViewController : UIViewController <GPPShareDelegate, UIActionSheetDelegate, UIWebViewDelegate, LoginDelegate, SelectDelegate>
{
     NSTimer *myticker;
    NSDate *today;
    UIImage *imgDeal;
    UIScrollView *scroll;
    BOOL isIphone5;
    UIImage *img;
    MBProgressHUD *hud;
}
@property (retain, nonatomic) GPPShare *share;
@property (nonatomic, retain) Offerta *offertaSelezionata;
@property (nonatomic, retain) IBOutlet  UILabel *lblCountdown;
@property (nonatomic, retain) IBOutlet  UIBarButtonItem *btnAction;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@property (retain, nonatomic) IBOutlet UIButton *btnAcquista;

-(IBAction)vaiAPagamento:(id)sender;
-(IBAction)showActionSheet:(id)sender;

@end
