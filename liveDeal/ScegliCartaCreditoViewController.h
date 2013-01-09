//
//  ScegliCartaCreditoViewController.h
//  liveDeal
//
//  Created by claudio barbera on 08/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditCard.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Offerta.h"
#import "SuccessViewController.h"

@interface ScegliCartaCreditoViewController : UITableViewController
{
    MBProgressHUD *hud;
    NSMutableData *tempArray;
    int cardId;
    NSIndexPath *old;
  }

@property (nonatomic, retain) NSArray *elencoCarte;
@property (nonatomic,retain) id<SelectDelegate> delegate;
@property (nonatomic, retain) NSString *chiavePagamento;
@property (nonatomic, retain) Offerta *offertaSelezionata;



@end
