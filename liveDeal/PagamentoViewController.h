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

@interface PagamentoViewController : UIViewController <SelectDelegate>
{
     UIImage *imgDeal;
    
}

@property (nonatomic, retain) IBOutlet CustomLabel *lblTitolo;
@property (nonatomic, retain) IBOutlet CustomLabel *lblDescrizione;
@property (nonatomic, retain) IBOutlet UIImageView  *img;
@property (nonatomic, retain) IBOutlet UILabel *lblValidita;
@property (nonatomic, retain) IBOutlet UILabel *lblQta;
@property (nonatomic, retain) IBOutlet UILabel *lblTot;
@property (nonatomic, retain) IBOutlet UIButton *btnPaga;
@property (nonatomic, retain) Offerta *offertaSelezionata;
@property (nonatomic, retain) IBOutlet UIImageView *imgCell;
@property (nonatomic, retain) IBOutlet UIImageView *imgPaypal;
@property (nonatomic, retain) IBOutlet UILabel *lblCC;



- (IBAction)goBack:(id)sender;
- (IBAction)incrementa:(id)sender;
- (IBAction)decrementa:(id)sender;
- (IBAction)test:(id)sender;

@end
