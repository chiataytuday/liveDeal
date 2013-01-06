//
//  SuccessViewController.h
//  liveDeal
//
//  Created by claudio barbera on 03/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventKit/EventKit.h"
#import "Offerta.h"
#import "CustomLabel.h"

@interface SuccessViewController : UIViewController
{
    EKEventStore *store;
}

@property (nonatomic, retain) Offerta *offertaSelezionata;
@property (nonatomic, retain) IBOutlet CustomLabel *lblTitolo;
@property (nonatomic, retain) IBOutlet UIButton *btnAddReminder;

-(IBAction)addToCalendar:(id)sender;
-(IBAction)addReminder:(id)sender;
-(IBAction)backToHome:(id)sender;
@end
