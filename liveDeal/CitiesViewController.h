//
//  CitiesViewController.h
//  liveDeal
//
//  Created by claudio barbera on 13/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Citta.h"
#import "AppDelegate.h"


@interface CitiesViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableData *tempArray;
    MBProgressHUD *hud;
   IBOutlet UISearchBar *searchBar;
    
}
@property (nonatomic, retain) NSMutableArray *citta;
@property (nonatomic,retain) id<SelectDelegate> delegate;



@end
