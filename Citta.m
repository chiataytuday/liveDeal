//
//  Citta.m
//  liveDeal
//
//  Created by claudio barbera on 13/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "Citta.h"

@implementation Citta
@synthesize Descrizione, Coordinate, Slug, foto;

-(id)initWithDescrizione:(NSString *)descrizione{
    
    self = [super init];
    
    if (self != nil)
    {
        
        self.Descrizione = descrizione;
    }
    
    return self;
    
}


@end
