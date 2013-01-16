//
//  BrowserViewController.h
//  liveDeal
//
//  Created by claudio barbera on 14/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BrowserViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIWebView *browser;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic,retain) id<SelectDelegate> delegate;

-(IBAction)close:(id)sender;

@end
