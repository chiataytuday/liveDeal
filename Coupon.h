//
//  Coupon.h
//  liveDeal
//
//  Created by claudio barbera on 27/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <Foundation/Foundation.h>
#define COUPON_ATTIVO 0
#define COUPON_SCADUTO 1
#define COUPON_UTILIZZATO 2

@interface Coupon : NSObject
@property (nonatomic, assign) int stato;
@property (nonatomic, retain) NSString *codice;
@property (nonatomic, retain) NSString *codiceSicurezza;


@end
