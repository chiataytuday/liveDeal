//
//  YelpViewController.h
//  liveDeal
//
//  Created by claudio barbera on 08/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "OAuthConsumer.h"
#import "Esercente.h"
#import "AppDelegate.h"

@interface YelpViewController : UITableViewController
{
     NSMutableData *_responseData;
    MBProgressHUD *hud;

}
@property (nonatomic, retain) NSMutableArray *Esercenti;
@end
