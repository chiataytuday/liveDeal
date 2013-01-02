//
//  PagamentoViewController.h
//  liveDeal
//
//  Created by claudio barbera on 29/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Offerta.h"
#import "CustomLabel.h"
#import "AppDelegate.h"
#import "ScegliPagamentoViewController.h"
#import "LoginViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "PayPal.h"

typedef enum PaymentStatuses {
	PAYMENTSTATUS_SUCCESS,
	PAYMENTSTATUS_FAILED,
	PAYMENTSTATUS_CANCELED,
} PaymentStatus;


@interface PagamentoViewController : UIViewController <SelectDelegate, PayPalPaymentDelegate, UIAlertViewDelegate>
{
     UIImage *imgDeal;
    PaymentStatus status;
    double tot;
    BOOL isIphone5;
    MBProgressHUD *hud;
    NSMutableData *tempArray;

}

@property (nonatomic, retain) IBOutlet CustomLabel *lblTitolo;
@property (nonatomic, retain) IBOutlet CustomLabel *lblDescrizione;
@property (nonatomic, retain) IBOutlet UIImageView  *img;
@property (nonatomic, retain) IBOutlet UIImageView  *imgBorder;
@property (nonatomic, retain) IBOutlet UILabel *lblValidita;
@property (nonatomic, retain) IBOutlet UILabel *lblQta;
@property (nonatomic, retain) IBOutlet UILabel *lblTot;
@property (nonatomic, retain) IBOutlet UIButton *btnPaga;
@property (nonatomic, retain) Offerta *offertaSelezionata;
@property (nonatomic, retain) IBOutlet UIImageView *imgCell;
@property (nonatomic, retain) IBOutlet UIImageView *imgPaypal;
@property (nonatomic, retain) IBOutlet UILabel *lblCC;
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
@property (retain, nonatomic) UIButton *paypalButton;
@property (nonatomic, retain) LoginViewController *loginController;


- (IBAction)incrementa:(id)sender;
- (IBAction)decrementa:(id)sender;


@end
