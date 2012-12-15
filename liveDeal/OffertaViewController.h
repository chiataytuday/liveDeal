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

@interface OffertaViewController : UIViewController <GPPShareDelegate, UIActionSheetDelegate, UIWebViewDelegate>
{
     NSTimer *myticker;
    NSDate *today;
    UIImage *imgDeal;
    UIScrollView *scroll;
}
@property (retain, nonatomic) GPPShare *share;
@property (nonatomic, retain) Offerta *offertaSelezionata;
@property (nonatomic, retain) IBOutlet  UILabel *lblCountdown;
@property (nonatomic, retain) IBOutlet  UIBarButtonItem *btnAction;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@property (retain, nonatomic) IBOutlet UIButton *btnAcquista;
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)goBack:(id)sender;
-(IBAction)showActionSheet:(id)sender;

@end
