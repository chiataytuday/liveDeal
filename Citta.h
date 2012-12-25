//
//  Citta.h
//  liveDeal
//
//  Created by claudio barbera on 13/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"
#import "Citta.h"

@interface Citta : NSObject

@property (nonatomic, retain) NSString *Descrizione;
@property (nonatomic, retain) NSString *Slug;
@property (nonatomic, assign) CLLocationCoordinate2D Coordinate;
@property (nonatomic, retain) NSString *foto;

-(id)initWithDescrizione:(NSString *)descrizione;

@end