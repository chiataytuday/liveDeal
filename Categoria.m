//
//  Categoria.m
//  liveDeal
//
//  Created by claudio barbera on 11/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "Categoria.h"

@implementation Categoria

@synthesize Descrizione, Codice, TipiGoogle, ColoreCornice, Slug;

-(NSArray *)DatiGoogle
{
    if (self.Slug==@"beauty")
    {
        NSArray *dati = [[NSArray alloc] initWithObjects:@"hair_care", @"beauty_salon",nil];
        
        return  dati;
    }
    
    return nil;
}
@end
