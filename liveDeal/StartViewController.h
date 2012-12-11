//
//  StartViewController.h
//  liveDeal
//
//  Created by claudio barbera on 13/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferteViewController.h"
#import "CitiesViewController.h"
#import "CategorieViewController.h"

@interface StartViewController : UIViewController<SelectDelegate>
@property (nonatomic, assign) CLLocationCoordinate2D Coordinate;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mapButtonItem;
@property (nonatomic, retain) IBOutlet UILabel *lblCurrentAddress;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *wait;


@end
