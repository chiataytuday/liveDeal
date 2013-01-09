//
//  CreditCard.h
//  liveDeal
//
//  Created by claudio barbera on 08/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditCard : NSObject

@property (nonatomic, assign) int Id;
@property (nonatomic, retain) NSString *cardtype;
@property (nonatomic, retain) NSString *expdate;
@property (nonatomic, retain) NSString *cardlastfourdigits;
@property (nonatomic, retain) NSString *description_card;
@property (nonatomic, retain) NSString *description_cardtype;
@property (nonatomic, retain) NSString *description_cardexpiry;



@end
