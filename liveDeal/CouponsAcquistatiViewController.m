//
//  CouponsAcquistatiViewController.m
//  liveDeal
//
//  Created by claudio barbera on 28/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "CouponsAcquistatiViewController.h"

@interface CouponsAcquistatiViewController ()

@end

@implementation CouponsAcquistatiViewController
@synthesize offertaSelezionata, coupons, sortedKey, mostraScaduti;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];

    
     NSMutableArray *tempUtilizzati = [[NSMutableArray alloc]init];
     NSMutableArray *tempValidi = [[NSMutableArray alloc]init];
     NSMutableArray *tempScaduti = [[NSMutableArray alloc]init];
    
    for (Coupon *coupon in offertaSelezionata.Coupons) {
        
        if (coupon.stato== COUPON_UTILIZZATO)
            [tempUtilizzati addObject:coupon];
        else if (coupon.stato== COUPON_SCADUTO)
            [tempScaduti addObject:coupon];
        else if (coupon.stato == COUPON_ATTIVO)
            [tempValidi addObject:coupon];
    }
    
    
    
    coupons =[[NSDictionary alloc]
                       initWithObjectsAndKeys:tempUtilizzati,@"Utilizzati",tempValidi,@"Validi", tempScaduti, @"Scaduti", nil];
    
      NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(localizedCompare:)];
    
      sortedKey =[[self.coupons allKeys]
                     sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (mostraScaduti)
        return [sortedKey count];
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *listData =[coupons objectForKey:[sortedKey objectAtIndex:section]];
 
    if (!mostraScaduti)
    {
        if ([[sortedKey objectAtIndex:section] isEqualToString:@"Validi"]){
             if ([listData count]>0)
                 return [listData count];
             else
             {
                 return 1;
             }
        }
        else
            return 1;
    }
    
    if ([listData count]>0)
        return [listData count];
    else
        return 1;
}
   

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 19;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}

 -(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 
     UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 19)];
     [v setBackgroundColor:[UIColor colorWithRed:47.0f / 255 green:47.0f / 255 blue:47.0f / 255 alpha:1]];
     
     UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.bounds.size.width - 10, 10)];
     
     if (mostraScaduti)
     {
         label.text = [self.sortedKey objectAtIndex:section];
         
     }
     else
     {
         if (![[sortedKey objectAtIndex:section] isEqualToString:@"Validi"])
         {
             label.text = @"Utilizzati e scaduti";
         }
         else
             label.text = [self.sortedKey objectAtIndex:section];
         
     }
    
     
     label.textColor = [UIColor whiteColor];
     [label setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
     label.backgroundColor = [UIColor clearColor];
     
     [v addSubview:label];
     
     return v;
     
 }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    
    NSArray *listData =[coupons objectForKey:[sortedKey objectAtIndex:[indexPath section]]];
   
    
    if (!mostraScaduti){
        if (![[sortedKey objectAtIndex:indexPath.section] isEqualToString:@"Validi"])
        {
            static NSString *CellIdentifier = @"mostraScadutiCell";
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                 
            }
            [self customizeCell:cell];
            return cell;
        }
    }
    
    if ([listData count]==0){
        
        static NSString *CellIdentifier = @"nessunCouponCell";
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
             
        }
        
        UILabel *lblTitolo = (UILabel *)[cell viewWithTag:1];
        
        [lblTitolo setText:[NSString stringWithFormat:@"Non sono presenti coupons %@", [[sortedKey objectAtIndex:indexPath.section] lowercaseString]]];
    }
    else
    {
        static NSString *CellIdentifier = @"couponCell";
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [self customizeCell:cell];
        }
        
        NSArray *listData =[self.coupons objectForKey:
                            [self.sortedKey objectAtIndex:[indexPath section]]];
        
        Coupon *c = [listData objectAtIndex:indexPath.row];
        
        CustomLabel *lblCodice = (CustomLabel *)[cell viewWithTag:1];
        lblCodice.text = [c codice];
        
        CustomLabel *lblCodiceSicurezza = (CustomLabel *)[cell viewWithTag:2];
        lblCodiceSicurezza.text = [c codiceSicurezza];
        
        
        
    }
    
    [self customizeCell:cell];
    return cell;
}

-(IBAction)mostraScaduti:(id)sender{

    mostraScaduti = !mostraScaduti;
    
    [self.tableView reloadData];
}

-(UITableViewCell *)customizeCell:(UITableViewCell *)cell
{
    //aspetto della cella
    UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 78)];
    av.backgroundColor = [UIColor clearColor];
    av.opaque = NO;
    av.image = [UIImage imageNamed:@"baseCell.png"];
    cell.backgroundView = av;
    
    UIView *cellBackView = [[UIView alloc] initWithFrame:CGRectZero];
    cellBackView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"sfondoCellOfferta.png"]];
    cell.backgroundView = cellBackView;
    


    return cell;
}
@end
