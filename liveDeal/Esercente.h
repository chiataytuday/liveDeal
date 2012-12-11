//
//  Esercente.h
//  liveDeal
//
//  Created by claudio barbera on 11/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface Esercente : NSObject

@property (nonatomic, retain) NSString *RagioneSociale;
@property (nonatomic, retain) NSString *Codice;
@property (nonatomic, retain) NSString *Indirizzo;
@property (nonatomic, retain) NSString *Telefono;
@property (nonatomic, retain) NSString *WebSite;
@property (nonatomic, retain) NSMutableArray *immagini;
@property (nonatomic, assign) CLLocationCoordinate2D Coordinate;
@property (nonatomic, assign) CLLocationDistance distanza;

-(id)initWithRagioneSociale:(NSString *)laRagioneSociale Codice:(NSString *)codice Indirizzo:(NSString *)indirizzo Coordinate:(CLLocationCoordinate2D)coord;
@end
