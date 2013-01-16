//
//  PostToFbViewController.m
//  liveDeal
//
//  Created by claudio barbera on 16/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import "PostToFbViewController.h"

@interface PostToFbViewController ()

@end

@implementation PostToFbViewController
@synthesize titolo, url, img, text, image, delegate, toolbar;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [toolbar setBackgroundImage:[UIImage imageNamed:@"backgroundTop.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    [text setText:titolo];
    [image setImage:img];
  }


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)cancel:(id)sender {
       [self.delegate didSelect:@"CANCEL" andIdentifier:@"post"];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)post:(id)sender {
    
    NSMutableDictionary *postParams =  [[NSMutableDictionary alloc] initWithObjectsAndKeys:url, @"link", nil, @"picture",
        titolo, @"name",nil];
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:postParams
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
                              [self.delegate didSelect:@"OK" andIdentifier:@"post"];
                            
                          }];
    
    [self dismissModalViewControllerAnimated:YES];
}



@end
