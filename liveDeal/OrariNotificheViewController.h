//
//  OrariNotificheViewController.h
//  liveDeal
//
//  Created by claudio barbera on 04/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Utility.h"

@interface OrariNotificheViewController : UIViewController

@property (nonatomic,retain) id<SelectDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *lblOrarioNotifiche;
@property (nonatomic, retain) IBOutlet UIDatePicker *timePicker;

-(IBAction)selezionaData:(id)sender;

@end
