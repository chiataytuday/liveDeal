//
//  Esercente.m
//  liveDeal
//
//  Created by claudio barbera on 11/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "Esercente.h"

@implementation Esercente

@synthesize RagioneSociale, Codice, Coordinate, immagini, distanza;

-(id)initWithRagioneSociale:(NSString *)laRagioneSociale Codice:(NSString *)codice Indirizzo:(NSString *)indirizzo Coordinate:(CLLocationCoordinate2D)coord{
    
    self = [super init];
    
    if (self != nil)
    {
        
        immagini = [[NSMutableArray alloc] initWithCapacity:1];
        self.RagioneSociale = laRagioneSociale;
        self.Codice = codice;
        self.Indirizzo =indirizzo;
        self.Coordinate = coord;
        
    }
    
    return self;
    
}
@end
