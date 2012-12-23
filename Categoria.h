//
//  Categoria.h
//  liveDeal
//
//  Created by claudio barbera on 11/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categoria : NSObject


@property (nonatomic, retain) NSString *Descrizione;
@property (nonatomic, assign) int Codice;
@property (nonatomic, retain) NSString *Slug;
@property (nonatomic, retain) NSString *TipiGoogle;
@property (nonatomic, retain) UIColor *ColoreCornice;


@end