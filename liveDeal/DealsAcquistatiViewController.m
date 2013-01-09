//
//  CouponsViewController.m
//  liveDeal
//
//  Created by claudio barbera on 18/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "DealsAcquistatiViewController.h"

@interface DealsAcquistatiViewController ()

@end

@implementation DealsAcquistatiViewController
@synthesize deals;



static char * const myIndexPathAssociationKey = "";



- (void)viewDidLoad
{
    
    [super viewDidLoad];

    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];

    imageQueue_ = dispatch_queue_create("com.company.app.imageQueue", NULL);

    
    NSString *url = [NSString stringWithFormat:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/get_coupons?token_access=%@&get_info_deal=true&status=all", [[NSUserDefaults standardUserDefaults] objectForKey:@"token_access"]];
    
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
    return 1; //[deals count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{/*
    NSArray *listData =[deals objectForKey:
                        [sortedKey objectAtIndex:section]];
    
    if ([listData count]==0)
        return 1;
    */
        return [deals count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    UITableViewCell *cell = nil;
 
 
        static NSString *CellIdentifier = @"couponCell";

        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    
    objc_setAssociatedObject(cell,
                             myIndexPathAssociationKey,
                             indexPath,
                             OBJC_ASSOCIATION_RETAIN);
    
        Offerta *offerta = [deals objectAtIndex:indexPath.row];
        
        //label titolo
        CustomLabel *lblTitolo = (CustomLabel *)[cell viewWithTag:1];
        [lblTitolo setText:offerta.Titolo];
        [lblTitolo setLineHeight:10];
        [lblTitolo setVerticalAlignment:MSLabelVerticalAlignmentTop];
        
        // [cellTitolo setFont:[UIFont fontWithName:@"Bebas Neue" size:18]];
        [lblTitolo setTextColor:[UIColor colorWithRed:43.0f / 255
                                                green:45.0f / 255
                                                 blue:48.0f / 255 alpha:1.0f]];
        
     
    UILabel *lblCoup = (UILabel *)[cell viewWithTag:4];
    [lblCoup setText:[NSString stringWithFormat:@"%i coupon acquistati", [offerta.Coupons count]]];
        UIImageView *cellImage = (UIImageView *)[cell viewWithTag:3];
        UIImageView *cellBorder = (UIImageView *)[cell viewWithTag:6];
        
        [cellImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [cellImage.layer setBorderWidth: 3.0];
        
        [cellImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [cellImage.layer setBorderWidth: 3.0];
        [cellBorder.layer setBorderColor:[offerta.Categoria.ColoreCornice CGColor]];
        [cellBorder.layer setBorderWidth: 1.0];
        
        
    if (offerta.Immagine) {
        [cellImage setImage:offerta.Immagine];
    } else {
    
        
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

        dispatch_async(queue  , ^{
            
            NSString *url = [NSString stringWithFormat:@"http://www.specialdeal.it/crop/80x80/%@", [offerta.immagini objectAtIndex:0]];
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexPath *cellIndexPath = (NSIndexPath *)objc_getAssociatedObject(cell, myIndexPathAssociationKey);
                if ([indexPath isEqual:cellIndexPath]) {

                    [offerta setImmagine:[UIImage imageWithData:imageData]];
                    cellImage.image = [UIImage imageWithData:imageData];
                    
                    if (tableView)
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                }
                
                
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return 80;
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
    deals = [[NSMutableArray alloc] init];
    
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:tempArray
                     options:kNilOptions error:nil];
    
    
    NSArray *result = [json valueForKeyPath:@"result"];
    NSArray *items = [result valueForKeyPath:@"items"];
    
    if (items)
    {
       
        
        for (NSDictionary *off in items)
        {
            NSDictionary *deal = [off objectForKey:@"Deal"];
            NSArray *duc = [off objectForKey:@"DealUserCoupon"];
            NSDictionary *image = [deal objectForKey:@"image"];
            
            Offerta *o = [[Offerta alloc] init];
            
            [o setTitolo:[deal objectForKey:@"name"]];
            [o setId:[[deal objectForKey:@"id"] intValue]];
            AppDelegate *app =  (AppDelegate *)[[UIApplication sharedApplication]delegate];
            
            Categoria *c = [app getCategoriaById:[[deal objectForKey:@"deal_category_id"] intValue]];
            [o setCategoria: c];
            
            [o.immagini addObject:[image objectForKey:@"id"]];
            
            for (NSDictionary *coupon in duc)
            {
                Coupon *cp = [[Coupon alloc] init];
                
                cp.codice = [coupon objectForKey:@"coupon_code"];
                cp.codiceSicurezza = [coupon objectForKey:@"coupon_unique_code"];
                
                
                
                if ([[coupon objectForKey:@"is_used"] boolValue])
                {
                    cp.stato = COUPON_UTILIZZATO;
                    
                }
                else if  ([[coupon objectForKey:@"is_expired"] boolValue])
                {
                    cp.stato = COUPON_SCADUTO;
                    
                }
                else
                {
                    cp.stato = COUPON_ATTIVO;
                    
                }
                
                
                [o.Coupons addObject:cp];
            }
            
            [deals addObject:o];
        }
          [hud hide:YES];
                [self.tableView reloadData];

    }
    else
    {
          [hud hide:YES];
        
         NSDictionary *error = [json valueForKeyPath:@"error"];
        
        if ([[error objectForKey:@"code"] intValue] == 502 ||
            [[error objectForKey:@"code"] intValue] == 503
            )
        {
           
            //[self.logDelegate didDisconnectForInvalidToken];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Il token d'autorizzazione non è più valido. Effettuare la disconnessione, quindi eseguire nuovamente il login" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            
            [alert show];
            
                       
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [hud hide:YES];
   
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"couponAcquistati"]) {
        
        
        // Get reference to the destination view controller
        CouponsAcquistatiViewController *vc = [segue destinationViewController];
        
        // get the selected index
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        
        vc.offertaSelezionata = [deals objectAtIndex:selectedIndex];
    }
}
@end
