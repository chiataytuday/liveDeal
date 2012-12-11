//
//  EsercenteViewController.m
//  liveDeal
//
//  Created by claudio barbera on 12/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "EsercenteViewController.h"

@interface EsercenteViewController ()

@end

@implementation EsercenteViewController
@synthesize esercenteSelezionato, lblRagioneSociale, lblIndirizzo, lblTelefono, lblWebSite, img;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [lblRagioneSociale setText:esercenteSelezionato.RagioneSociale];
    [lblIndirizzo setText:esercenteSelezionato.Indirizzo];
    
    self.title = esercenteSelezionato.RagioneSociale;
   NSString *url = [NSString stringWithFormat: @"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@", esercenteSelezionato.Codice, GOOGLE_PLACES_KEY ];
               
    [self Ricerca:url];

}

-(void)Ricerca:(NSString *)searchText
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:searchText]  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    
    
    NSURLConnection *myConn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (!myConn)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
        tempArray = [[NSMutableData alloc] init];

}


#pragma mark - dati relativi alla connessione

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    [tempArray setLength:0];
}


- (void)showPhotoView
{
	
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:esercenteSelezionato.immagini.count];
    
    if (esercenteSelezionato.immagini.count >= 1){
    
        for (int i=0; i<= [esercenteSelezionato.immagini count] -1; i++) {
            MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[NSURL URLWithString:[esercenteSelezionato.immagini objectAtIndex:i]] name:[esercenteSelezionato.immagini objectAtIndex:i] ];
            [temp addObject:photo];
            
        }
        MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:[NSArray arrayWithArray:temp]];
        
        EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
        [photoController.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController pushViewController:photoController animated:YES];
        
        
    }
   
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data{
    
    [tempArray appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
        
    
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:tempArray //1
                     options:kNilOptions error:nil];
    
    
    NSArray *items = [json valueForKeyPath:@"result"];
    
    
     NSArray *foto = [items valueForKey:@"photos"];
    
    if ([foto count]>=1)
    {
        [esercenteSelezionato.immagini removeAllObjects];
        
        for (NSDictionary *f in foto)
        {
            NSString *fotoEserc = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=true&key=%@", [f valueForKey:@"photo_reference"], GOOGLE_PLACES_KEY];
            [esercenteSelezionato.immagini addObject:fotoEserc];
            
        }
    }
    
    
    esercenteSelezionato.Telefono = [items valueForKey:@"international_phone_number"];
    esercenteSelezionato.WebSite = [items valueForKey:@"website"];

    [lblTelefono setText:esercenteSelezionato.Telefono];    
    [lblWebSite setText:esercenteSelezionato.WebSite];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[esercenteSelezionato.immagini objectAtIndex:0]]];
        
        UIImage *imgData = [UIImage imageWithData:data];
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            img.image = imgData;
            [img setNeedsLayout];
        });
    });
    
       
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
   
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore"
                                                   message:@"Impossibile connettersi"
                                                  delegate:nil
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSString *phoneLinkString = [NSString stringWithFormat:@"tel:%@", [esercenteSelezionato.Telefono stringByReplacingOccurrencesOfString:@" "
                                                                                                                                   withString:@""]];
        NSURL *phoneLinkURL = [NSURL URLWithString:phoneLinkString];
        [[UIApplication sharedApplication] openURL:phoneLinkURL];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==1 ) //chiamata telefonica
    {
        if ( indexPath.row == 0)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Chiamare" message:esercenteSelezionato.Telefono delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si", nil];
            av.delegate = self;
            [av show];            
        }
        else if (indexPath.row==1)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:esercenteSelezionato.WebSite]];
        else if (indexPath.row==2)
        {
            [self showPhotoView];
        }
    }
    if (indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            Class itemClass = [MKMapItem class];
            if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
                
            
                MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                MKPlacemark *pl = [[MKPlacemark alloc] initWithCoordinate:esercenteSelezionato.Coordinate addressDictionary:nil];
                
                MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:pl];
                
                                                                             
                toLocation.name = @"Destination";
                [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                               launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                         forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];

                
            
            }
            else if (indexPath.row==1)
            {
                NSMutableString *mapURL = [NSMutableString stringWithString:@"http://maps.google.com/maps?"];
                [mapURL appendFormat:@"saddr=Current Location"];
                [mapURL appendFormat:@"&daddr=%f,%f", esercenteSelezionato.Coordinate.latitude, esercenteSelezionato.Coordinate.longitude];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[mapURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            }
            
        }
       
    }
}
@end
