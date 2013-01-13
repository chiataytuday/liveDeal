//
//  PreferenzeViewController.h
//  liveDeal
//
//  Created by claudio barbera on 04/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "OrariNotificheViewController.h"
#import "Utility.h"
#import "RaggioRicercaViewController.h"

@interface PreferenzeViewController : UITableViewController<SelectDelegate>

@property (nonatomic, retain) IBOutlet UILabel *lblOrarioNotifiche;
@property (nonatomic, retain) IBOutlet UILabel *lblRaggioRicerca;

@end
