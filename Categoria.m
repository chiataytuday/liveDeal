//
//  Categoria.m
//  liveDeal
//
//  Created by claudio barbera on 11/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "Categoria.h"

@implementation Categoria

@synthesize Descrizione, Codice, Immagine, TipiGoogle, TipiLiveDeal, ColoreCornice;

-(id)initWithDescrizione:(NSString *)laDescrizione codice:(NSString *)ilCodice immagine:(NSString *)img andArrayOfTypes:(NSString *)tipiDiGoogle{

    self = [super init];
    
    if (self != nil)
    {
        
        self.Codice = ilCodice;
        self.Descrizione = laDescrizione;
        self.Immagine = img;
        self.TipiGoogle = tipiDiGoogle;
    }
    
    return self;
    
}

-(NSArray *)DatiGoogle
{
    if (self.Codice==@"beauty")
    {
        NSArray *dati = [[NSArray alloc] initWithObjects:@"hair_care", @"beauty_salon",nil];
        
        return  dati;
    }
    
    return nil;
}
@end
