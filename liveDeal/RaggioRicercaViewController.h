//
//  RaggioRicercaViewController.h
//  liveDeal
//
//  Created by claudio barbera on 13/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RaggioRicercaViewController : UIViewController
@property (nonatomic, retain) IBOutlet UILabel *lblRaggio;
@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic,retain) id<SelectDelegate> delegate;

-(IBAction)modificaRaggio:(id)sender;
@end
