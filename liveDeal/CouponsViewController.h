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

@interface CouponsViewController : UITableViewController
{
    NSMutableData *tempArray;
    MBProgressHUD *hud;

}

@property (nonatomic, retain) NSDictionary *coupons;
@property (nonatomic, retain) NSArray *sortedKey;
@end
