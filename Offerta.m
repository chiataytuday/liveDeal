//
//  Offerta.m
//  liveDeal
//
//  Created by claudio barbera on 13/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "Offerta.h"

@implementation Offerta

@synthesize Titolo, Descrizione, Condizioni, Validita, Sconto, PrezzoPartenza, Esercente, CouponAcquistati ,immagini, DataScadenza, Url, Immagine, Categoria, distanza, isLive, DataInizio, Id, Coupons, Subdeals;


-(id)init
{
    self = [super init];
    
    if (self != nil)
    {
        immagini = [[NSMutableArray alloc] initWithCapacity:1];
        Subdeals = [[NSMutableArray alloc] init];
        Coupons = [[NSMutableArray alloc] init];
    }
    
    return self;
}
@end
