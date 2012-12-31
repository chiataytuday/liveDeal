//
//  CouponsAcquistatiViewController.h
//  liveDeal
//
//  Created by claudio barbera on 28/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Offerta.h"
#import "Coupon.h"
#import "CustomLabel.h"
#import "QuartzCore/QuartzCore.h"

@interface CouponsAcquistatiViewController : UITableViewController
{
    NSMutableData *tempArray;
    MBProgressHUD *hud;
    
}

@property (nonatomic, retain) Offerta *offertaSelezionata;
@property (nonatomic, retain) NSDictionary *coupons;
@property (nonatomic, retain) NSArray *sortedKey;
@property (nonatomic, assign) BOOL mostraScaduti;

-(IBAction)mostraScaduti:(id)sender;
@end
