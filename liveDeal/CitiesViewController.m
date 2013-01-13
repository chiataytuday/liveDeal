//
//  CitiesViewController.m
//  liveDeal
//
//  Created by claudio barbera on 13/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "CitiesViewController.h"

@interface CitiesViewController ()

@end

@implementation CitiesViewController
@synthesize citta;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.citta  =  ((AppDelegate *)[[UIApplication sharedApplication]delegate]).citta;
}


-(void)RicercaWithLatitude:(CGFloat)lat andLongitude:(CGFloat)lng andRadius:(CGFloat)radius
{
    //lat=37.5149&lng=15.082512&radius=80";
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/_city_list_by_coordinate?lat=%f&lng=%ff&radius=%dx",
                           37.5149, 15.082512, 80];
    
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
          [self.delegate didSelect:nil andIdentifier:@"citta"] ;
        /*
        CLLocation *location = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).locationManager.location;
        
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
       
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
            
            if (error){
                NSLog(@"Geocode failed with error: %@", error);
                
            }
            if(placemarks && placemarks.count > 0)
            {
                //do something
                CLPlacemark *topResult = [placemarks objectAtIndex:0];
                    
                Citta *c= [[Citta alloc] initWithDescrizione:topResult.locality];
                c.Slug = topResult.locality;
                c.Coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
              
                
                [self.delegate didSelect:c andIdentifier:@"citta"] ;
            }
        }];
         */
    }else
    {
        Citta *city = [citta objectAtIndex:indexPath.row -1];
        [self.delegate didSelect:city andIdentifier:@"citta"] ;
        
    }
    
   
    
    [self.navigationController popViewControllerAnimated:YES];    
}

#pragma mark - Table view Data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [citta count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    
    static NSString *CellIdentifier = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    
    if (indexPath.row==0)
    {
        [cellLabel setText:@"Posizione attuale.."];
    }
    else
    {
        Citta *city = [citta objectAtIndex:indexPath.row - 1]; 
        
        [cellLabel setText:city.Descrizione];
    }
       
    return cell;
}


@end
