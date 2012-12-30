//
//  CouponsViewController.h
//  liveDeal
//
//  Created by claudio barbera on 18/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Offerta.h"
#import "Esercente.h"
#import "QuartzCore/QuartzCore.h"
#import "CustomLabel.h"
#import "AppDelegate.h"
#import "Coupon.h"
#import "CouponsAcquistatiViewController.h"
#import <objc/runtime.h>
#import "LoginViewController.h"

@interface DealsAcquistatiViewController : UITableViewController
{
    NSMutableData *tempArray;
    MBProgressHUD *hud;
    dispatch_queue_t imageQueue_;
 }

//@property (nonatomic, retain) NSDictionary *deals;
//@property (nonatomic, retain) NSArray *sortedKey;
@property (nonatomic, retain) NSMutableArray *deals;
@property(nonatomic, retain) id<LoginDelegate> logDelegate;

@end
