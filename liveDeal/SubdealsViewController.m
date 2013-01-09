//
//  SubdealsViewController.m
//  liveDeal
//
//  Created by claudio barbera on 09/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import "SubdealsViewController.h"

@interface SubdealsViewController ()

@end

@implementation SubdealsViewController
@synthesize offertaSelezionata;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
   }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([[segue identifier] isEqualToString:@"pagamento"]) {
        
        
        // Get reference to the destination view controller
        PagamentoViewController *vc = [segue destinationViewController];
        

        vc.offertaSelezionata = offertaSelezionata;
       
       NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
       
       vc.opzioneSelezionata = [offertaSelezionata.Subdeals objectAtIndex:selectedIndex];

       
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
    return [offertaSelezionata.Subdeals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"subdeal";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    UILabel *lblDescrizione = (UILabel *)[cell viewWithTag:1];
    UILabel *lblPrezzo = (UILabel *)[cell viewWithTag:2];
    UILabel *lblSconto = (UILabel *)[cell viewWithTag:3];

    
    OpzioneOfferta *sub = [offertaSelezionata.Subdeals objectAtIndex:indexPath.row];
    
    [lblDescrizione setText:sub.descrizione];
    [lblPrezzo setText:[NSString stringWithFormat:@"Prezzo: %.2f€", sub.PrezzoFinale]];
    [lblSconto setText:[NSString stringWithFormat:@"Sconto: %.2f", sub.Sconto]];
    return cell;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
