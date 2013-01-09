//
//  OpzioneOfferta.h
//  liveDeal
//
//  Created by claudio barbera on 09/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpzioneOfferta : NSObject

@property (nonatomic, assign) int Id;
@property (nonatomic, retain) NSString *descrizione;
@property (nonatomic, assign) double Sconto;
@property (nonatomic, assign) double PrezzoFinale;
@property (nonatomic, assign) double PrezzoPartenza;
@end
