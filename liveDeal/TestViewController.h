//
//  TestViewController.h
//  liveDeal
//
//  Created by claudio barbera on 31/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPal.h"


typedef enum PaymentStatuses {
	PAYMENTSTATUS_SUCCESS,
	PAYMENTSTATUS_FAILED,
	PAYMENTSTATUS_CANCELED,
} PaymentStatus;

@interface TestViewController : UIViewController <PayPalPaymentDelegate>
{

    PaymentStatus status;
}
@end
