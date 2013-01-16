//
//  PostToFbViewController.h
//  liveDeal
//
//  Created by claudio barbera on 16/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Social/Social.h"
#import "AdSupport/AdSupport.h"
#import "Accounts/Accounts.h"
#import "AppDelegate.h"

@interface PostToFbViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (retain, nonatomic) NSString *titolo;
@property (retain, nonatomic) UIImage *img;
@property (retain, nonatomic) NSString *url;
@property (nonatomic,retain) id<SelectDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)post:(id)sender;

@end
