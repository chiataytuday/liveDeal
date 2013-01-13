//
//  RaggioRicercaViewController.m
//  liveDeal
//
//  Created by claudio barbera on 13/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import "RaggioRicercaViewController.h"

@interface RaggioRicercaViewController ()

@end

@implementation RaggioRicercaViewController
@synthesize lblRaggio, slider, delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
     float radius = [[NSUserDefaults standardUserDefaults] floatForKey:@"searchRadius"];
    [slider setValue:radius];
    [self setRadius:radius];
    
}


-(IBAction)modificaRaggio:(id)sender
{
    float radius = ((UISlider *)sender).value;
    [self setRadius:radius];
   
}

-(void)setRadius:(float)radius
{
     [lblRaggio setText:[NSString stringWithFormat:@"%.0f Km", radius]];
    [[NSUserDefaults standardUserDefaults] setFloat:radius forKey:@"searchRadius"];
    
    [delegate didSelect:[NSString stringWithFormat:@"%.0f", radius]  andIdentifier:@"searchRadius"];
    
}
@end
