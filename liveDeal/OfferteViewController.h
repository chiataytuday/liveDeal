//
//  EsercentiViewController.h
//  liveDeal
//
//  Created by claudio barbera on 11/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Categoria.h"
#import "MBProgressHUD.h"
#import "Offerta.h"
#import "AppDelegate.h"
#import "MapKit/MapKit.h"
#import "OffertaAnnotation.h"
#import "EsercenteAnnotation.h"
#import "EsercenteVetrinaAnnotation.h"
#import "EsercenteViewController.h"
#import "OffertaViewController.h"
#import "CustomLabel.h"
#import "Citta.h"
#import "QuartzCore/QuartzCore.h"
#import "Utility.h"
#import "ODRefreshControl.h"
#import "EsercenteVetrinaViewController.h"
#import "OpzioneOfferta.h"

@interface OfferteViewController : UIViewController<UITableViewDelegate, MKMapViewDelegate, NSURLConnectionDelegate>
{
    NSMutableData *tempArray;
    MBProgressHUD *hud;
    int tipo;
    ODRefreshControl *refreshControl ;
       

}

@property (nonatomic, assign) BOOL isViewOffertaShow;
@property (nonatomic, retain) NSMutableArray *Offerte;
@property (nonatomic, retain) NSMutableArray *Esercenti;
@property (nonatomic, retain) NSMutableArray *EsercentiInVetrina;
@property (nonatomic, retain) Categoria *categoriaSelezionata;
@property (nonatomic, retain) Citta *cittaSelezionata;
@property (nonatomic, assign) BOOL isFood;
@property (nonatomic, retain) IBOutlet UITableView *myTable;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mapButton;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIView *gridView;
@property (nonatomic, retain) IBOutlet UIView *vwOfferta;
@property (nonatomic, retain) IBOutlet UIImageView *imgOffertaSelezionata;
@property (nonatomic, retain) IBOutlet UILabel *lblTitoloOffertaSelezionata;
@property (nonatomic, retain) IBOutlet UILabel *lblDescrizioneOffertaSelezionata;
@property (nonatomic, retain) IBOutlet UILabel *lblAcquistatiOffertaSelezionata;
@property (nonatomic, retain) NSString *nextPageToken;
@property (nonatomic, retain) NSString *tipiCategorie;

-(IBAction)switchMap:(id)sender;



@end
