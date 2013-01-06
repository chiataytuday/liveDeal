//
//  OrariNotificheViewController.m
//  liveDeal
//
//  Created by claudio barbera on 04/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import "OrariNotificheViewController.h"

@interface OrariNotificheViewController ()

@end

@implementation OrariNotificheViewController
@synthesize delegate, lblOrarioNotifiche, timePicker;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    
    [timePicker setDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"orarioNotifiche"]];
    
    [lblOrarioNotifiche setText:[NSString stringWithFormat:@"Sarai avvisato alle %@",  [Utility getStringFromHours:[timePicker date]]]];

}

-(IBAction)selezionaData:(id)sender
{
    UIDatePicker *pick = (UIDatePicker *)sender;
    [lblOrarioNotifiche setText:[NSString stringWithFormat:@"Sarai avvisato alle %@",  [Utility getStringFromHours:[pick date]]]];
    [delegate didSelect:[pick date] andIdentifier:@"orarioNotifiche"];
    
}

@end
