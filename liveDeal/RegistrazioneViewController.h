//
//  RegistrazioneViewController.h
//  liveDeal
//
//  Created by claudio barbera on 21/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TitoloViewController.h"
#import "Citta.h"
#import "CitiesViewController.h"

@interface RegistrazioneViewController : UIViewController <UITextFieldDelegate, SelectDelegate>
{
    UIScrollView *scroll;
}
@property (nonatomic, retain)  UITextField *txtNome;
@property (nonatomic, retain)  UITextField *txtCognome;
@property (nonatomic, retain)  UITextField *txtEmail;
@property (nonatomic, retain)  UITextField *txtPassword;
@property (nonatomic, retain)  UITextField *txtSesso;
@property (nonatomic, retain)  UITextField *txtCitta;
@property (nonatomic, retain)  UITextField *txtConfermaPassword;



@end
