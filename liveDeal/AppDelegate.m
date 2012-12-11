//
//  AppDelegate.m
//  liveDeal
//
//  Created by claudio barbera on 11/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize locationManager, isIphone5, session, citta, categorie;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self Ricerca:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/city_list?include_without_deals=true"];

    
    [FBProfilePictureView class];
    
    UIImage *navBarImage = [UIImage imageNamed:@"backgroundTop.png"];
    
    [[UINavigationBar appearance] setBackgroundImage:navBarImage
                                 forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];

   /*
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        UIStoryboard *storyBoard;
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        
        if(result.height == 1136){
            isIphone5=YES;
            storyBoard = [UIStoryboard storyboardWithName:@"Storyboard5" bundle:nil];
            UIViewController *initViewController = [storyBoard instantiateInitialViewController];
            [self.window setRootViewController:initViewController];
        }
    }
    
       */
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];

    [self caricaCategorie];
    return YES;
}


-(void)caricaCategorie{

    categorie = [[NSMutableArray alloc] init];
    
    
    Categoria *cat = [[Categoria alloc] initWithDescrizione:@"Tutte le offerte"
                                                     codice:@"all"
                                                   immagine:@"img"
                                            andArrayOfTypes: @"lodging%7Chair_care%7Cbeauty_salon"];
    
    [categorie addObject:cat];
    
    
    
    cat = [[Categoria alloc] initWithDescrizione:@"Hotel"
                                          codice:@"lodging"
                                        immagine:@"img"
                                 andArrayOfTypes: @"lodging"];
    cat.TipiLiveDeal = @"soggiorni";
    [cat setColoreCornice:[UIColor colorWithRed:245.0f / 255 green:101.0f / 255 blue:34.0f / 255 alpha:1]];

    [categorie addObject:cat];
    
    
    cat = [[Categoria alloc] initWithDescrizione:@"Wellness"
                                          codice:@"beauty"
                                        immagine:@"img"
                                 andArrayOfTypes:@"hair_care%7Cbeauty_salon"];
    cat.TipiLiveDeal = @"benessere";
    [cat setColoreCornice:[UIColor colorWithRed:245.0f / 255 green:101.0f / 255 blue:34.0f / 255 alpha:1]];

    [categorie addObject:cat];

    
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.absoluteString hasPrefix:@"fb"])
        return [FBSession.activeSession handleOpenURL:url];
    else
    {
        if ([self.share handleURL:url
                sourceApplication:sourceApplication
                       annotation:annotation]) {
            return YES;
        }
    }
    
    return NO;
}


//locationManager:didUpdateToLocation:fromLocation
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidBecomeActive:(UIApplication *)application	{
    
    // We need to properly handle activation of the application with regards to SSO
    // (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
    
  }


-(void)Ricerca:(NSString *)url
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    
    
    NSURLConnection *myConn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (myConn)
    {
        tempArray = [[NSMutableData alloc] init];
        
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore"
                                                       message:@"Impossibile connettersi"
                                                      delegate:nil
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:nil];
        
        [alert show];
    }
}

#pragma mark - dati relativi alla connessione

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    [tempArray setLength:0];
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data{
    
    [tempArray appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    citta = [[NSMutableArray alloc] init];
    
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:tempArray
                     options:kNilOptions error:nil];
    
    
    NSArray *result = [json valueForKeyPath:@"result"];
    NSArray *items = [result valueForKeyPath:@"items"];
    
    for (NSDictionary *d in items)
    {
        Citta *c = [[Citta alloc] initWithDescrizione:[d valueForKey:@"display"]];
        
        NSArray *foto = [d valueForKey:@"images"];
        
        c.foto =[foto valueForKey:@"id"];
        
        
        
        c.Coordinate = CLLocationCoordinate2DMake([[d valueForKey:@"latitude"] doubleValue], [[d valueForKey:@"longitude"] doubleValue]);
        c.Slug = [d valueForKey:@"slug"];
        [citta addObject:c];
    }
    
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
   
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}
@end
