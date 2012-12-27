//
//  UserDetailViewController.m
//  liveDeal
//
//  Created by claudio barbera on 27/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "UserDetailViewController.h"

@interface UserDetailViewController ()

@end

@implementation UserDetailViewController
@synthesize user, lblCognome, lblNome, lblSesso, lblEMail;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sfondoUser.png"]]];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    [lblNome setText:user.nome];
    [lblCognome setText:user.cognome];
    [lblSesso setText:user.sesso];
    [lblEMail setText:user.email];
}



@end
