//
//  CategorieViewController.h
//  liveDeal
//
//  Created by claudio barbera on 11/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Categoria.h"
#import "OfferteViewController.h"
#import "Citta.h"
#import "AppDelegate.h"

@interface CategorieViewController : UITableViewController 


@property (nonatomic, retain) NSMutableArray *Categorie;
@property (nonatomic, retain) Citta *cittaSelezionata;

@end
