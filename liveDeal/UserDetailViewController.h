//
//  UserDetailViewController.h
//  liveDeal
//
//  Created by claudio barbera on 27/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserDetailViewController : UIViewController
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) IBOutlet UILabel *lblNome;
@property (nonatomic, retain) IBOutlet UILabel *lblCognome;
@property (nonatomic, retain) IBOutlet UILabel *lblSesso;
@property (nonatomic, retain) IBOutlet UILabel *lblEMail;
@end
