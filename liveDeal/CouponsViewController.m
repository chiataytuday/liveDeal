//
//  CouponsViewController.m
//  liveDeal
//
//  Created by claudio barbera on 18/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "CouponsViewController.h"

@interface CouponsViewController ()

@end

@implementation CouponsViewController
@synthesize coupons, sortedKey;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];

    
    NSString *url = [NSString stringWithFormat:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/get_coupons?token_access=%@&get_info_deal=true", [[NSUserDefaults standardUserDefaults] objectForKey:@"token_access"]];
    
    [self Ricerca:url];
}


-(void)Ricerca:(NSString *)searchText
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:searchText]  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    
    
    NSURLConnection *myConn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (myConn)
    {
        tempArray = [[NSMutableData alloc] init];
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Caricamento dati...";
        
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
   return [sortedKey count];}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *listData =[coupons objectForKey:
                        [sortedKey objectAtIndex:section]];
    
    if ([listData count]==0)
        return 1;
    
    return [listData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    UITableViewCell *cell = nil;
 
    NSArray *listData =[coupons objectForKey:
                        [sortedKey objectAtIndex:[indexPath section]]];
 
    
    if ([listData count]==0){
    
        static NSString *CellIdentifier = @"nessunCouponCell";
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        UILabel *lblTitolo = (UILabel *)[cell viewWithTag:1];
        
        [self.sortedKey objectAtIndex:indexPath.section];
        
        [lblTitolo setText:[NSString stringWithFormat:@"Non sono presenti coupons %@", [[self.sortedKey objectAtIndex:indexPath.section] lowercaseString]]];
        
        
    }
    else
    {
        static NSString *CellIdentifier = @"couponCell";

        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        Offerta *offerta = [listData objectAtIndex:indexPath.row];
        
        //label titolo
        CustomLabel *lblTitolo = (CustomLabel *)[cell viewWithTag:1];
        [lblTitolo setText:offerta.Titolo];
        [lblTitolo setLineHeight:10];
        [lblTitolo setVerticalAlignment:MSLabelVerticalAlignmentTop];
        
        // [cellTitolo setFont:[UIFont fontWithName:@"Bebas Neue" size:18]];
        [lblTitolo setTextColor:[UIColor colorWithRed:43.0f / 255
                                                green:45.0f / 255
                                                 blue:48.0f / 255 alpha:1.0f]];
        
     
         
        UIImageView *cellImage = (UIImageView *)[cell viewWithTag:3];
        UIImageView *cellBorder = (UIImageView *)[cell viewWithTag:6];
        
        [cellImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [cellImage.layer setBorderWidth: 3.0];
        
        [cellImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [cellImage.layer setBorderWidth: 3.0];
        [cellBorder.layer setBorderColor:[offerta.Categoria.ColoreCornice CGColor]];
        [cellBorder.layer setBorderWidth: 1.0];
        
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            
            NSString *url = [NSString stringWithFormat:@"http://www.specialdeal.it/crop/80x80/%i", offerta.Id];
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
            
            UIImage *img = [UIImage imageWithData:data];
            
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                offerta.Immagine = img;
                cellImage.image = img;
                [cellImage setNeedsLayout];
            });
        });
        

    }
    
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


#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
   return 19;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listData =[coupons objectForKey:
                        [sortedKey objectAtIndex:indexPath.section]];
    
    if ([listData count]==0)
        return 44;

    
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 19)];
    [v setBackgroundColor:[UIColor colorWithRed:47.0f / 255 green:47.0f / 255 blue:47.0f / 255 alpha:1]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.bounds.size.width - 10, 10)];
    
   
    label.text = [self.sortedKey objectAtIndex:section];
   
    
      label.textColor = [UIColor whiteColor];
    [label setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    label.backgroundColor = [UIColor clearColor];
    
    [v addSubview:label];
    
    return v;
    

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
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:tempArray
                     options:kNilOptions error:nil];
    
    
    NSArray *result = [json valueForKeyPath:@"result"];
    NSArray *items = [result valueForKeyPath:@"items"];
    
    NSMutableArray *tempUtilizzati = [[NSMutableArray alloc]init];
    NSMutableArray *tempValidi = [[NSMutableArray alloc]init];
    NSMutableArray *tempScaduti = [[NSMutableArray alloc]init];
    
    for (NSDictionary *off in items)
    {
        NSDictionary *deal = [off objectForKey:@"Deal"];
        NSArray *du = [off objectForKey:@"DealUserCoupon"];
        Offerta *o = [[Offerta alloc] init];
        [o setTitolo:[deal objectForKey:@"name"]];
        [o setId:[[deal objectForKey:@"id"] intValue]];
        AppDelegate *app =  (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        Categoria *c = [app getCategoriaById:[[deal objectForKey:@"deal_category_id"] intValue]];
        [o setCategoria: c];
        NSDictionary *a = [du objectAtIndex:0];
        
        if ([[a objectForKey:@"is_used"] boolValue])
        {
            [tempUtilizzati addObject:o];
        }
        else if  ([[a objectForKey:@"is_expired"] boolValue])
        {
            [tempScaduti addObject:o];
        }
        else
        {
            [tempValidi addObject:o];
        }
        
    }
    
   coupons =[[NSDictionary alloc]
                         initWithObjectsAndKeys:tempUtilizzati,@"Utilizzati",tempValidi,@"Validi", tempScaduti, @"Scaduti", nil];
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(localizedCompare:)];

    sortedKey =[[self.coupons allKeys]
                     sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    [hud hide:YES];
    [self.tableView reloadData];

    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [hud hide:YES];
   
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

@end
