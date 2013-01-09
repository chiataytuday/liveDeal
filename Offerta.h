//
//  Offerta.h
//  liveDeal
//
//  Created by claudio barbera on 13/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Esercente.h"
#import "Categoria.h"

@interface Offerta : NSObject


@property (nonatomic, retain) NSString *Titolo;
@property (nonatomic, assign) double PrezzoPartenza;
@property (nonatomic, retain) NSString *DataInizio;
@property (nonatomic, retain) NSString *DataScadenza;
@property (nonatomic, retain) NSString *DataFineValidita;
@property (nonatomic, assign) double Sconto;
@property (nonatomic, assign) double PrezzoFinale;
@property (nonatomic, retain) NSString *Descrizione;
@property (nonatomic, retain) NSString *Condizioni;
@property (nonatomic, retain) NSString *Url;
@property (nonatomic, retain) NSString *Validita;
@property (nonatomic, retain) NSMutableArray *immagini;
@property (nonatomic, retain) UIImage *Immagine;
@property (nonatomic, retain) Esercente *Esercente;
@property (nonatomic, assign) int CouponAcquistati;
@property (nonatomic, retain) Categoria *Categoria;
@property (nonatomic, assign) CLLocationDistance distanza;
@property (nonatomic, assign) BOOL isLive;
@property (nonatomic, assign) int Id;
@property (nonatomic, retain) NSMutableArray *Coupons;
@property (nonatomic, retain) NSMutableArray *Subdeals;

@end
