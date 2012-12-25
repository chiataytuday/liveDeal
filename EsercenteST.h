//
//  EsercenteST.h
//  liveDeal
//
//  Created by claudio barbera on 25/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EsercenteST : NSManagedObject

@property (nonatomic, retain) NSString * ragioneSociale;
@property (nonatomic, retain) NSString * codice;
@property (nonatomic, retain) NSString * indirizzo;
@property (nonatomic, retain) NSString * immagine;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
