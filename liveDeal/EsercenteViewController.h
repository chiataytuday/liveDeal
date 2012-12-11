//
//  EsercenteViewController.h
//  liveDeal
//
//  Created by claudio barbera on 12/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Esercente.h"
#import "AppDelegate.h"
#import "EGOPhotoGlobal.h"
#import "MyPhoto.h"
#import "MyPhotoSource.h"


@interface EsercenteViewController : UITableViewController<UIAlertViewDelegate>{
 NSMutableData *tempArray;
}


@property (nonatomic, retain) Esercente *esercenteSelezionato;
@property (nonatomic, retain) IBOutlet UILabel *lblRagioneSociale;
@property (nonatomic, retain) IBOutlet UILabel *lblIndirizzo;
@property (nonatomic, retain) IBOutlet UILabel *lblTelefono;
@property (nonatomic, retain) IBOutlet UILabel *lblWebSite;
@property (nonatomic, retain) IBOutlet UIImageView *img;

- (void)showPhotoView;

@end
