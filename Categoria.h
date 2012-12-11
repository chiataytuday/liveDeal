//
//  Categoria.h
//  liveDeal
//
//  Created by claudio barbera on 11/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categoria : NSObject
{
    NSString *descrizione;
    NSString *codice;
    NSString *immagine;
    NSString *tipiGoogle;
}

@property (nonatomic, retain) NSString *Descrizione;
@property (nonatomic, retain) NSString *Codice;
@property (nonatomic, retain) NSString *Immagine;
@property (nonatomic, retain) NSString *TipiGoogle;
@property (nonatomic, retain) NSString *TipiLiveDeal;
@property (nonatomic, retain) UIColor *ColoreCornice;

-(id)initWithDescrizione:(NSString *)laDescrizione codice:(NSString *)ilCodice immagine:(NSString *)img andArrayOfTypes:(NSString *)tipiGoogle;

@end