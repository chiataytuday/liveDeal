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

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];

    
    UIImageView *imgSfondo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sfondoRegistrati.png"]];
    [imgSfondo setContentMode:UIViewContentModeScaleAspectFill];
    
    [imgSfondo setFrame:self.view.frame];
    
    self.tableView.backgroundView = imgSfondo;
    
   NSMutableArray *tempArray = ((AppDelegate *)[[UIApplication sharedApplication]delegate]).categorie;
    
    self.Categorie  =   [[NSMutableArray alloc ] initWithCapacity:[tempArray count] - 1];
    
    for (Categoria *c in tempArray) {
        
        if (![c.Slug isEqualToString:@"ristoranti"])
        {
            [Categorie addObject:c];
        }
    }

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
    
    Categoria *cat = [Categorie objectAtIndex:indexPath.row];
    
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    [cellLabel setText:cat.Descrizione];
    [cellLabel setTextColor:cat.ColoreCornice];
    [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SfondoCellAltriEsercenti.png"]]];
    
    UIImageView *img = (UIImageView *)[cell viewWithTag:2];
    [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", cat.Slug]]];
    
    
     return cell;
    
}


#pragma mark - Table View Delegate

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Seleziona una categoria";
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
