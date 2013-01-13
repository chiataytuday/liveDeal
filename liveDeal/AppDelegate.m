//
//  AppDelegate.m
//  liveDeal
//
//  Created by claudio barbera on 11/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "AppDelegate.h"
#import "PayPal.h"

@implementation AppDelegate
@synthesize locationManager, isIphone5, session, citta, categorie, managedObjectContext, managedObjectModel, persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
        [[PayPal initializeWithAppID:PAYPAL_KEY forEnvironment:PAYPAL_ENVIRONMENT] setLang:@"it_IT"];
    
     if ([[NSUserDefaults standardUserDefaults] objectForKey:@"orarioNotifiche"]==nil)
     {
        
         NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
         [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         
         NSDate *d = [dateformatter dateFromString:@"2013-01-01 20:30:00"];
         
         [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"orarioNotifiche"];
         
     }
    
    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"searchRadius"]==0)
    {
        [[NSUserDefaults standardUserDefaults] setFloat:100 forKey:@"searchRadius"];
        
    }
    
     
    tipoRicerca=CITTA;
    
    [self Ricerca];
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
    locationManager.delegate = self;
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //[self caricaCategorie];
    return YES;
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *strTemp = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
       
    [defaults setObject: strTemp forKey:@"tokenAPN"];
    [defaults synchronize];
    
	NSLog(@"My token is: %@", strTemp);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	//NSLog(@"Failed to get token, error: %@", error);
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.absoluteString hasPrefix:@"fb"])
        return [FBSession.activeSession handleOpenURL:url];
    else if ([url.absoluteString hasPrefix:@"livedeal"])
    {
        NSArray *res = [url pathComponents];

        NSString *status = [res objectAtIndex:2];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pagamentoNotificato" object:status];

    }
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


-(void)Ricerca
{
    
    NSString *urlString =@"";
    
    
    if (tipoRicerca==CITTA)
        urlString = @"http://www.specialdeal.it/api/jsonrpc2/v1/deals/city_list?include_without_deals=true";
    else
        urlString = @"http://www.specialdeal.it/api/jsonrpc2/v1/deals/category_list";
    
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
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

-(Categoria *)getCategoriaFood
{
    for (Categoria *c in categorie) {
        if ([c.Slug isEqualToString:@"ristoranti"])
            return  c;
    }
    
    
    return nil;
}

-(Categoria *)getCategoriaById:(int)Id
{
    for (Categoria *c in categorie) {
        if (c.Codice == Id)
            return  c;
    }
    
    
    return nil;
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
    if (tipoRicerca==CITTA)
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
        
        tipoRicerca=CATEGORIE;
        [self Ricerca];
    }
    else{
    
        categorie = [[NSMutableArray alloc] init];
        
        NSArray* json = [NSJSONSerialization
                         JSONObjectWithData:tempArray
                         options:kNilOptions error:nil];
        
        
        NSArray *result = [json valueForKeyPath:@"result"];
        NSArray *items = [result valueForKeyPath:@"items"];
        
        for (NSDictionary *d in items)
        {
            Categoria *c = [[Categoria alloc] init];
            [c setDescrizione:[d objectForKey:@"display"]];
            [c setCodice:[[d objectForKey:@"id"] intValue]];
            [c setSlug:[d objectForKey:@"slug"]];
            
            if (![[d objectForKey:@"framecolor"] isKindOfClass: [NSNull class]])
            {
                c.ColoreCornice = [UIColor colorWithHexString:[[d valueForKey:@"framecolor"] uppercaseString]];
                         }
            [c setTipiGoogle:[d objectForKey:@"gp"]];
            [categorie addObject:c];
        }

    }
    
    
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
   
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"LiveDeal.sqlite"]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}



@end
