//
//  StartViewController.m
//  liveDeal
//
//  Created by claudio barbera on 13/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController
@synthesize Coordinate, mapButtonItem,lblCurrentAddress, wait;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sfondoRegistrati.png"]]];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];

    
	// Do any additional setup after loading the view.
  //  [lblCurrentAddress setText:@"Localizzando..."];
   // [wait startAnimating];
    /*CLLocationCoordinate2D clloc = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).locationManager.location.coordinate;
 
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc]
                            initWithLatitude:clloc.latitude longitude:clloc.longitude];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
        
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            
        }
        if(placemarks && placemarks.count > 0)
        {
            //do something
            CLPlacemark *topResult = [placemarks objectAtIndex:0];
            
            NSMutableString *addressTxt = [[NSMutableString alloc] initWithCapacity:4];
            
            if (topResult.subThoroughfare!=nil)
                [addressTxt appendFormat:@"%@ - ", topResult.subThoroughfare];

            if (topResult.thoroughfare!=nil)
                [addressTxt appendFormat:@"%@, ", topResult.thoroughfare];
            
            if (topResult.locality!=nil)
                [addressTxt appendFormat:@"%@ ", topResult.locality];
            
            if (topResult.administrativeArea!=nil)
                [addressTxt appendFormat:@"(%@)", topResult.administrativeArea];

            lblCurrentAddress.text = addressTxt;
            [wait stopAnimating];
           
        }
    }];*/
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // BOOL spiga = [defaults boolForKey:@"spiga"];
    NSString *des = [defaults objectForKey:@"citta.display"];
    NSString *foto = [defaults objectForKey:@"citta.foto"];
   // NSString *sl = [defaults objectForKey:@"citta.slug"];
    
    if (foto!=nil)
    {
        NSNumber *idf = [defaults objectForKey:@"citta.foto"];
        [self aggiornaFoto: [idf stringValue]];
        
       
        
    }


    lblCurrentAddress.text = [NSString stringWithFormat:@"SpecialDeal - %@", des];
}


-(void)aggiornaFoto:(NSString *)idFoto
{
    if (idFoto==nil)
    {
       
               return;

    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    // the path to write file
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", idFoto]];

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:appFile];
	
    if (!fileExists)
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            
            NSString *url = [NSString stringWithFormat:@"http://www.specialdeal.it/crop/320x400/%@",idFoto];
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
            
            UIImage *img = [UIImage imageWithData:data];
            
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self.view setBackgroundColor:[UIColor colorWithPatternImage:img]];
              
                NSError *writeError = nil;
                [data writeToFile:appFile options:NSDataWritingAtomic error:&writeError];
                
            });
        });
    }
    else
    {
        UIImage* image = [UIImage imageWithContentsOfFile:appFile];
         [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];

    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    Coordinate = app.locationManager.location.coordinate;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // BOOL spiga = [defaults boolForKey:@"spiga"];
    NSString *des = [defaults objectForKey:@"citta.display"];
    NSString *sl = [defaults objectForKey:@"citta.slug"];
    float lat = [defaults floatForKey:@"citta.location.latitude"];
    float lon = [defaults floatForKey:@"citta.location.longitude"];
    
    
    Citta *c = [[Citta alloc] initWithDescrizione:des];
    c.Slug = sl;
    c.Coordinate = CLLocationCoordinate2DMake(lat, lon);
    

    
    if ([[segue identifier] isEqualToString:@"food"])
    {
        OfferteViewController *vc = [segue destinationViewController];
        vc.isFood = YES;
        vc.cittaSelezionata = c;
    }
    else if ([[segue identifier] isEqualToString:@"noFood"])
    {
        CategorieViewController *vc = [segue destinationViewController];
        vc.cittaSelezionata = c;
    }
    else if ([[segue identifier] isEqualToString:@"citta"])
    {
        CitiesViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }

    
}

-(void)didSelect:(id)object andIdentifier:(NSString *)identifier
{
    Citta *city = (Citta *)object;
    
    //memorizzo la città tra le preferenze
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:city.Descrizione forKey:@"citta.display"];
    [defaults setObject:city.foto forKey:@"citta.foto"];

    [defaults setObject:city.Slug forKey:@"citta.slug"];
    [defaults setFloat:city.Coordinate.latitude forKey:@"citta.location.latitude"];
    [defaults setFloat:city.Coordinate.longitude forKey:@"citta.location.longitude"];
    
    [defaults synchronize];
    
    lblCurrentAddress.text = [NSString stringWithFormat:@"SpecialDeal - %@", city.Descrizione];
    [self aggiornaFoto:city.foto];
    
}

@end
