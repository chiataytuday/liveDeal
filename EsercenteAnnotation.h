//
//  EsercenteAnnotation.h
//  liveDeal
//
//  Created by claudio barbera on 15/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface EsercenteAnnotation : NSObject <MKAnnotation>{
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (assign) id idEsercente;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;



@end
