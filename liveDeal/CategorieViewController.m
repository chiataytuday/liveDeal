//
//  CategorieViewController.m
//  liveDeal
//
//  Created by claudio barbera on 11/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "CategorieViewController.h"

@interface CategorieViewController ()

@end

@implementation CategorieViewController
@synthesize Categorie, cittaSelezionata;



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.Categorie  =  ((AppDelegate *)[[UIApplication sharedApplication]delegate]).categorie;

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [Categorie count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"categoriaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    [cellLabel setText:[[Categorie objectAtIndex:indexPath.row] Descrizione]];
    return cell;
    
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"elencoDeals"]) {
        
        
        // Get reference to the destination view controller
        OfferteViewController *vc = [segue destinationViewController];
        
        // get the selected index
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        vc.isFood=NO;
        vc.cittaSelezionata = cittaSelezionata;
        vc.categoriaSelezionata = [Categorie objectAtIndex:selectedIndex];
       
    }    
}



@end
