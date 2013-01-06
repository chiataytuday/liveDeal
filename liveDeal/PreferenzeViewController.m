//
//  PreferenzeViewController.m
//  liveDeal
//
//  Created by claudio barbera on 04/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import "PreferenzeViewController.h"

@interface PreferenzeViewController ()

@end

@implementation PreferenzeViewController
@synthesize lblOrarioNotifiche;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
      
    NSDate *d = [[NSUserDefaults standardUserDefaults] objectForKey:@"orarioNotifiche"];
    
    [lblOrarioNotifiche setText:[Utility getStringFromHours:d]];
}

-(void)didSelect:(id)object andIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:@"orarioNotifiche"])
    {
        NSDate *d = (NSDate *)object;           
        [lblOrarioNotifiche setText:[Utility getStringFromHours:d]];
        [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"orarioNotifiche"];
         
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
      
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"orarioNotifiche"])
    {
        OrariNotificheViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
}
@end
