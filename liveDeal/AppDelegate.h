//
//  AppDelegate.h
//  liveDeal
//
//  Created by claudio barbera on 11/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import "FacebookSDK/FacebookSDK.h"
#import "GPPShare.h"
#import "Citta.h"
#import "Categoria.h"

#define GOOGLE_PLACES_KEY @"AIzaSyCb2aMRq1POO-aXsj5XdvWEIgzm_7y8OkQ"

@protocol SelectDelegate <NSObject>

-(void)didSelect:(id)object andIdentifier:(NSString *)identifier;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableData *tempArray;
}
@property (retain, nonatomic) GPPShare *share;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isIphone5;
@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) NSMutableArray *citta;
@property (strong, nonatomic) NSMutableArray *categorie;


@end
