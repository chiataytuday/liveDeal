//
//  EsercenteVetrinaViewController.h
//  liveDeal
//
//  Created by claudio barbera on 24/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Esercente.h"

@interface EsercenteVetrinaViewController : UIViewController

@property (nonatomic, retain) Esercente *esercenteSelezionato;
@property (nonatomic, retain) IBOutlet UILabel *lblRagSoc;

@end
