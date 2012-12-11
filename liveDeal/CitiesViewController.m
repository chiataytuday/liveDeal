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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        
        
        CLLocationCoordinate2D clloc = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).locationManager.location.coordinate;
        
        
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
                    
                Citta *c= [[Citta alloc] initWithDescrizione:topResult.locality];
                c.Slug = topResult.locality;
                c.Coordinate = CLLocationCoordinate2DMake(clloc.latitude, clloc.longitude);
              
                
                [self.delegate didSelect:c andIdentifier:@"citta"] ;
            }
        }];

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
