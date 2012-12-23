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
@synthesize Offerte;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setOpaque:YES];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"couponCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
 
    UIView *cellBackView = [[UIView alloc] initWithFrame:CGRectZero];
    cellBackView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"sfondoCellAltriEsercenti.png"]];
    cell.backgroundView = cellBackView;

    UIImageView *cellImage = (UIImageView *)[cell viewWithTag:3];
    UIImageView *cellBorder = (UIImageView *)[cell viewWithTag:6];
    
    [cellImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [cellImage.layer setBorderWidth: 2.0];
    
    [cellBorder.layer setBorderColor:[[UIColor colorWithRed:245.0f / 255 green:101.0f / 255 blue:34.0f / 255 alpha:1] CGColor]];
    [cellBorder.layer setBorderWidth: 1.0];

    
    return cell;
}


#pragma mark - Table view delegate

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
    
    if (section==0)
        label.text = @"Utilizzati";
    else if (section ==1)
        label.text = @"Validi";
    else
        label.text = @"Scaduti";
    
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
    Offerte = [[NSMutableArray alloc] init];
    
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:tempArray
                     options:kNilOptions error:nil];
    
    
    NSArray *result = [json valueForKeyPath:@"result"];
    NSArray *items = [result valueForKeyPath:@"items"];
    
    
    for (NSDictionary *off in items)
    {
        
        NSDictionary *esercente = [off valueForKey:@"company"];
        NSDictionary *prices = [off valueForKey:@"prices"];
        NSDictionary *discounts = [off valueForKey:@"discounts"];
        NSDictionary *category = [off valueForKey:@"category"];        
        
        double lat = [[esercente valueForKey:@"latitude"] doubleValue];
        double lng = [[esercente valueForKey: @"longitude"] doubleValue];
        
        Esercente *es = [[Esercente alloc] initWithRagioneSociale:[esercente valueForKey:@"name"]
                                                           Codice:[esercente valueForKey:@"id"]
                                                        Indirizzo:[esercente valueForKey:@"address"]
                                                       Coordinate:CLLocationCoordinate2DMake(lat, lng)];
        
        
        Offerta *offerta = [[Offerta alloc] initWithTitolo:[off valueForKey:@"title"]
                                               Descrizione:[off valueForKey:@"description"]
                                                Condizioni:[off valueForKey:@"conditions"]];
        
        [offerta setIsLive:[[off valueForKey:@"is_live"] boolValue]];
        
        NSArray *images = [off valueForKey:@"images"];
        for (NSDictionary *img in images)
        {
            [offerta.immagini addObject:[[img valueForKey:@"id"] stringValue]];
            
        }
        
        [offerta setCategoria:[category valueForKey:@"slug"]];
        [offerta setValidita:[off valueForKey:@"validita"]];
        [offerta setUrl:[off valueForKey:@"url"]];
        [offerta setPrezzoFinale:[[prices valueForKey:@"discounted"] doubleValue]];
        [offerta setEsercente:es];
        [offerta setPrezzoPartenza:[[prices valueForKey:@"original"] doubleValue]];
        [offerta setSconto:[[discounts valueForKey:@"percentage"] doubleValue]];
        [offerta setDataInizio:[off valueForKey:@"start_date"]];
        [offerta setDataScadenza:[off valueForKey:@"end_date"]];
        [offerta setCouponAcquistati:[[off valueForKey:@"purchased"] integerValue]];
        
        [Offerte addObject:offerta];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [hud hide:YES];
   
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

@end
