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
    isShowed=false;
       
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sfondoHome.png"]]];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
   
    
   
    
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
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    Coordinate = app.locationManager.location.coordinate;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    Citta *c;
    
    if ([defaults objectForKey:@"citta.display"]!= nil)
    {
        NSString *des = [defaults objectForKey:@"citta.display"];
        NSString *sl = [defaults objectForKey:@"citta.slug"];
        float lat = [defaults floatForKey:@"citta.location.latitude"];
        float lon = [defaults floatForKey:@"citta.location.longitude"];
        
        c = [[Citta alloc] initWithDescrizione:des];
        
        c.Slug = sl;
        c.Coordinate = CLLocationCoordinate2DMake(lat, lon);
        

    }
 
    
    
   
    if ([[segue identifier] isEqualToString:@"food"])
    {
        OfferteViewController *vc = [segue destinationViewController];
        vc.isFood = YES;
        vc.categoriaSelezionata = [app getCategoriaFood];

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    if (object!=nil)
    {
        Citta *city = (Citta *)object;
        
        //memorizzo la città tra le preferenze
        
       
        [defaults setObject:city.Descrizione forKey:@"citta.display"];
        [defaults setObject:city.foto forKey:@"citta.foto"];
        
        [defaults setObject:city.Slug forKey:@"citta.slug"];
        [defaults setFloat:city.Coordinate.latitude forKey:@"citta.location.latitude"];
        [defaults setFloat:city.Coordinate.longitude forKey:@"citta.location.longitude"];
        
        
    }
    else
    {
        [defaults setObject:nil forKey:@"citta.display"];
        [defaults setObject:nil forKey:@"citta.foto"];
        
        [defaults setObject:nil forKey:@"citta.slug"];
        [defaults setFloat:0 forKey:@"citta.location.latitude"];
        [defaults setFloat:0 forKey:@"citta.location.longitude"];
    }
    [defaults synchronize];

}

@end
