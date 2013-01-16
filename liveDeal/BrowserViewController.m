//
//  BrowserViewController.m
//  liveDeal
//
//  Created by claudio barbera on 14/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import "BrowserViewController.h"

@interface BrowserViewController ()

@end

@implementation BrowserViewController
@synthesize browser, url;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [browser loadRequest:[NSURLRequest requestWithURL:url]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(paymentNotification:)
                                                 name:@"pagamentoNotificato"
                                               object:nil];

}

-(void )paymentNotification:(NSNotification *)notification
{
    
    NSString *r = notification.object;
    
    if ([r isEqualToString:@"PAID"])
        [self.delegate didSelect:@"OK" andIdentifier:@"statoPagamento"];
       // [self performSegueWithIdentifier:@"pagamentoOk" sender:self];
    else{
        [self.delegate didSelect:@"KO" andIdentifier:@"statoPagamento"];
                
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
