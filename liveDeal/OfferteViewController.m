//
//  EsercentiViewController.m
//  liveDeal
//
//  Created by claudio barbera on 11/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "OfferteViewController.h"

@interface OfferteViewController ()

@end

@implementation OfferteViewController
@synthesize Offerte, Esercenti, categoriaSelezionata, myTable, mapButton, mapView, gridView, vwOfferta, isViewOffertaShow, imgOffertaSelezionata, lblAcquistatiOffertaSelezionata, lblDescrizioneOffertaSelezionata, lblTitoloOffertaSelezionata, nextPageToken, cittaSelezionata;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];

    
    nextPageToken = @"";
    Esercenti = [[NSMutableArray alloc] init];
    //UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sfondoRegistrati.png"]];
    //[tempImageView setContentMode:UIViewContentModeScaleAspectFill];
    //[tempImageView setFrame:self.self.myTable.frame];
    
    //self.self.myTable.backgroundView = tempImageView;
    
    [self.mapView setHidden:YES];
    tipo=0; //offerte
    [self Ricerca:[NSString stringWithFormat:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/deals_list?city=%@", cittaSelezionata.Slug]];;
    
    
    
}

-(IBAction)switchMap:(id)sender{


    if (mapButton.tag==1)
    {
        
        vwOfferta.frame = CGRectMake(vwOfferta.frame.origin.x,
                                     self.view.frame.size.height,
                                     self.view.frame.size.width,
                                     0);
        
        [UIView beginAnimations:@"flipView" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
         mapButton.tag=2;
        [mapView setHidden:NO];
        [gridView setHidden:YES];
        [UIView commitAnimations];
        
    }
    else
    {
        [UIView beginAnimations:@"flipView" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        mapButton.tag=1;
        [mapView setHidden:YES];
        [gridView setHidden:NO];
        [UIView commitAnimations];

    }
}

-(void)Ricerca:(NSString *)searchText
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:searchText]  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    
    
    NSURLConnection *myConn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (myConn)
    {
        tempArray = [[NSMutableData alloc] init];
        
        if (tipo==0){
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"Caricamento dati...";
        }
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        
        [alert show];
    }
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
    CLLocationCoordinate2D clloc = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).locationManager.location.coordinate;

    
    CLLocation *newLocation = [[CLLocation alloc] initWithCoordinate: clloc altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];

    
    if (tipo==0){
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
           
            CLLocation *distanzaEsercente = [[CLLocation alloc] initWithCoordinate: CLLocationCoordinate2DMake(lat, lng) altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];

            offerta.distanza = [newLocation distanceFromLocation:distanzaEsercente] / 1000;
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
            [offerta setDataScadenza:[off valueForKey:@"end_date"]];
            [offerta setCouponAcquistati:[[off valueForKey:@"purchased"] integerValue]];
           
        
        
             OffertaAnnotation *annotation = [[OffertaAnnotation alloc] initWithName:offerta.Titolo
                                                                            address:offerta.Esercente.Indirizzo
                                                                        coordinate:CLLocationCoordinate2DMake(lat, lng)];
            
            if (self.isFood)
            {
                if ([offerta.categoria isEqualToString:@"ristoranti"])
                {
                    [Offerte addObject:offerta];
                    [annotation setOfferta:offerta];                    
                    [mapView addAnnotation:annotation];
                }
            }
           else
           {
               if (![offerta.categoria isEqualToString:@"ristoranti"])
               {
                   //se la sottocategoria selezionata è tutte le offerte mostro sempre
                   if ([categoriaSelezionata.Codice isEqualToString:@"all"])
                   {
                       [Offerte addObject:offerta];
                       [annotation setOfferta:offerta];
                       [mapView addAnnotation:annotation];
                   }
                   else
                   {
                       if ([categoriaSelezionata.TipiLiveDeal isEqualToString:offerta.categoria])
                       {
                           [Offerte addObject:offerta];
                           [annotation setOfferta:offerta];
                           [mapView addAnnotation:annotation];

                       }
                   }
                   
               }
           }
        }
    
        //carico gli esercenti in zona
        tipo=1;
        
       //  CLLocationCoordinate2D clloc = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).locationManager.location.coordinate;
        
        NSString *strUrl=@"";
        if (categoriaSelezionata!=nil)
        {
            strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&rankby=distance&types=%@&sensor=false&key=%@",
                      cittaSelezionata.Coordinate.latitude,
                      cittaSelezionata.Coordinate.longitude,
                      categoriaSelezionata.TipiGoogle,
                      GOOGLE_PLACES_KEY];
        
        }
        else
            strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&rankby=distance&types=food&sensor=false&key=%@",
                      cittaSelezionata.Coordinate.latitude,
                      cittaSelezionata.Coordinate.longitude,
                      GOOGLE_PLACES_KEY];

        
        [self Ricerca:strUrl];
    
    
    }
    else if (tipo==1)
    {
        
        
        NSArray* json = [NSJSONSerialization
                         JSONObjectWithData:tempArray //1
                         options:kNilOptions error:nil];
        
                nextPageToken = [json valueForKey:@"next_page_token"];
        
        
        NSArray *items = [json valueForKeyPath:@"results"];   
       

        
        for (NSDictionary *esercenti in items)
        {
            NSArray *foto = [esercenti valueForKey:@"photos"];
           
            NSDictionary *geometry = [esercenti valueForKey:@"geometry"];
            NSDictionary *location = [geometry valueForKey:@"location"];
            
            double lat = [[location valueForKey:@"lat"] doubleValue];
            double lng = [[location valueForKey: @"lng"] doubleValue];
            
            Esercente *es = [[Esercente alloc] initWithRagioneSociale:[esercenti valueForKey:@"name"]
                                                               Codice:[esercenti valueForKey:@"reference"]
                                                            Indirizzo:[esercenti valueForKey:@"vicinity"]
                                                           Coordinate:CLLocationCoordinate2DMake(lat, lng)];
            
            CLLocation *distanzaEsercente = [[CLLocation alloc] initWithCoordinate: CLLocationCoordinate2DMake(lat, lng) altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
            
            es.distanza = [newLocation distanceFromLocation:distanzaEsercente] / 1000;

            
            
            if ([foto count]>=1)
                for (NSDictionary *f in foto)
                {
                      NSString *img = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=true&key=%@", [f valueForKey:@"photo_reference"], GOOGLE_PLACES_KEY];
                    [es.immagini addObject:img];
                   
                }
            else
                [es.immagini addObject:[esercenti valueForKey:@"icon"]];
            
                        
            
             EsercenteAnnotation *annot = [[EsercenteAnnotation alloc] initWithName:[esercenti valueForKey:@"name"]
                                                                            address:[esercenti valueForKey:@"vicinity"]
                                                                         coordinate:CLLocationCoordinate2DMake(lat, lng)];
            [annot setIdEsercente:es];
            [mapView addAnnotation:annot];
            [Esercenti addObject:es];
        }
        
        
        [hud hide:YES];
        [myTable reloadData];

    } 
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   // Return the number of sections.
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2)
        return 60;
    
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1)
        return 19;
    else return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1)
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 19)];
        [v setBackgroundColor:[UIColor colorWithRed:47.0f / 255 green:47.0f / 255 blue:47.0f / 255 alpha:1]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.bounds.size.width - 10, 10)];
        label.text = @"Altri esercenti nelle vicinanze";
        label.textColor = [UIColor whiteColor];
        [label setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
        label.backgroundColor = [UIColor clearColor];
        
        [v addSubview:label];
        
        return v;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section==0)
        return [Offerte count];
    else if (section == 1)
        return [Esercenti count];
    else if (section==2)
    {
        if (nextPageToken!=nil)
            return 1;
    }
        
           
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   
    if (section==1)
        return @"Altri esercenti nelle vicinanze";
    else if (section==0)
        return @"";
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section==0){
    
        //offerte
        
         Offerta *offerta = [Offerte objectAtIndex:indexPath.row];        
        
        if (offerta.isLive)
        {
            static NSString *CellIdentifier = @"offertaLiveCell";
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            CustomLabel *lblTitolo = (CustomLabel *)[cell viewWithTag:1];
            [lblTitolo setText:offerta.Titolo];
            [lblTitolo setLineHeight:10];
            [lblTitolo setVerticalAlignment:MSLabelVerticalAlignmentTop];
            
            // [cellTitolo setFont:[UIFont fontWithName:@"Bebas Neue" size:18]];
            [lblTitolo setTextColor:[UIColor colorWithRed:43.0f / 255
                                                    green:45.0f / 255
                                                     blue:48.0f / 255 alpha:1.0f]];
            
            UILabel *lblPrezzo = (UILabel *)[cell viewWithTag:2];
            [lblPrezzo setText:[NSString stringWithFormat:@"%.2f€", offerta.PrezzoFinale]];
            [lblPrezzo setTextColor:[UIColor colorWithRed:255.0f / 255
                                                    green:77.0f / 255
                                                     blue:137.0f / 255 alpha:1.0f]];
            
             UILabel *cellDescrizione = (UILabel *)[cell viewWithTag:5];
            
            cellDescrizione.text = [NSString stringWithFormat:@"%@   -   %.2f Km", offerta.Esercente.RagioneSociale, offerta.distanza];
            
            //label prezzo
            
            
            [cellDescrizione setBackgroundColor:[UIColor clearColor]];
            cellDescrizione.opaque = NO;
            cellDescrizione.backgroundColor = [UIColor clearColor];
            [self hideGradientBackground:cellDescrizione];
            
            UILabel *lblValidita = (UILabel *)[cell viewWithTag:4];
        /*
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *currentDate = [dateformatter dateFromString:offerta.DataScadenza];
            
            NSDate *today = [NSDate date];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            int unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *components = [gregorian components:unitFlags fromDate:today toDate:currentDate options:0];
            
            if (components.day==1)*/
            lblValidita.text = [NSString stringWithFormat:@"Utilizzabile domani dalle 08:00 alle 23:59"];
            
            if ([offerta.immagini count]>=1)
            {
                
                UIImageView *cellImage = (UIImageView *)[cell viewWithTag:3];
                UIImageView *cellBorder = (UIImageView *)[cell viewWithTag:6];
                
                [cellImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                [cellImage.layer setBorderWidth: 3.0];
                
                [cellBorder.layer setBorderColor:[[UIColor colorWithRed:245.0f / 255 green:101.0f / 255 blue:34.0f / 255 alpha:1] CGColor]];
                [cellBorder.layer setBorderWidth: 1.0];
                
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                
                dispatch_async(queue, ^{
                    
                    NSString *url = [NSString stringWithFormat:@"http://www.specialdeal.it/crop/80x80/%@",[offerta.immagini objectAtIndex:0]];
                    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
                    
                    UIImage *img = [UIImage imageWithData:data];
                    
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        offerta.Immagine = img;
                        cellImage.image = img;
                        [cellImage setNeedsLayout];
                    });
                });
            }


            
        }
        else
        {
            static NSString *CellIdentifier = @"offertaCell";
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            //aspetto della cella
            UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 78)];
            av.backgroundColor = [UIColor clearColor];
            av.opaque = NO;
            av.image = [UIImage imageNamed:@"baseCell.png"];
            cell.backgroundView = av;
            
            
            //label titolo
            CustomLabel *lblTitolo = (CustomLabel *)[cell viewWithTag:1];
            [lblTitolo setText:offerta.Titolo];
            [lblTitolo setLineHeight:10];
            [lblTitolo setVerticalAlignment:MSLabelVerticalAlignmentTop];
            
            // [cellTitolo setFont:[UIFont fontWithName:@"Bebas Neue" size:18]];
            [lblTitolo setTextColor:[UIColor colorWithRed:43.0f / 255
                                                    green:45.0f / 255
                                                     blue:48.0f / 255 alpha:1.0f]];
            
            
            
            UIImageView *ticket = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ticket.png"]];
            [ticket setFrame:CGRectMake(65, 30, 28,36)];
            
            
            UILabel *lblPercSconto = [[UILabel alloc] initWithFrame:CGRectMake(1,12, 30, 30)];
            
            [lblPercSconto setFont:[UIFont fontWithName:@"Helvetica" size:10]];
            [lblPercSconto setText:[NSString stringWithFormat:@"%.f%%", offerta.Sconto]];
            [lblPercSconto setTextColor:[UIColor whiteColor]];
            [lblPercSconto setBackgroundColor:[UIColor clearColor]];
            
            //rotate label in 45 degrees
            lblPercSconto.transform = CGAffineTransformMakeRotation( 70 * M_PI / 180);
            
            //  lblPercSconto.frame = CGRectIntegral(lblPercSconto.frame);
            
            [ticket addSubview:lblPercSconto];
            
            
            [cell addSubview:ticket];
            
            UILabel *cellDescrizione = (UILabel *)[cell viewWithTag:2];
            cellDescrizione.text = [NSString stringWithFormat:@"%@   -   %.2f Km", offerta.Esercente.RagioneSociale, offerta.distanza];
            
            //label prezzo
            
            
            [cellDescrizione setBackgroundColor:[UIColor clearColor]];
            cellDescrizione.opaque = NO;
            cellDescrizione.backgroundColor = [UIColor clearColor];
            [self hideGradientBackground:cellDescrizione];
            
            UILabelStrikethrough *lblPrezzoOriginario = (UILabelStrikethrough *)[cell viewWithTag:7];
            [lblPrezzoOriginario setText:[NSString stringWithFormat:@"%.2f€", offerta.PrezzoPartenza]];
                       
            UILabel *lblPrezzo = (UILabel *)[cell viewWithTag:4];
            [lblPrezzo setText:[NSString stringWithFormat:@"%.2f€", offerta.PrezzoFinale]];
            [lblPrezzo setTextColor:[UIColor colorWithRed:255.0f / 255
                                                    green:77.0f / 255
                                                     blue:137.0f / 255 alpha:1.0f]];
            
            
            //label offerta
            UILabel *lblOfferta = (UILabel *)[cell viewWithTag:5];
            [lblOfferta setText: [NSString stringWithFormat:@"Valido fino al %@", offerta.DataScadenza]];
            
            
            
            if ([offerta.immagini count]>=1)
            {
                
                UIImageView *cellImage = (UIImageView *)[cell viewWithTag:3];
                UIImageView *cellBorder = (UIImageView *)[cell viewWithTag:6];
                
                [cellImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                [cellImage.layer setBorderWidth: 3.0];
                
                [cellBorder.layer setBorderColor:[[UIColor colorWithRed:245.0f / 255 green:101.0f / 255 blue:34.0f / 255 alpha:1] CGColor]];
                [cellBorder.layer setBorderWidth: 1.8];
                
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                
                dispatch_async(queue, ^{
                    
                    NSString *url = [NSString stringWithFormat:@"http://www.specialdeal.it/crop/80x80/%@",[offerta.immagini objectAtIndex:0]];
                    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
                    
                    UIImage *img = [UIImage imageWithData:data];
                    
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        offerta.Immagine = img;
                        cellImage.image = img;
                        [cellImage setNeedsLayout];
                    });
                });
            }
        } UIView *cellBackView = [[UIView alloc] initWithFrame:CGRectZero];
        cellBackView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"sfondoCellOfferta.png"]];
        cell.backgroundView = cellBackView;
         
        
    }
    else if (indexPath.section==1){

    
        //altri esercenti
        //offerte
        static NSString *CellIdentifier = @"esercenteCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        Esercente *es = [Esercenti objectAtIndex:indexPath.row];
        
        UILabel *cellRagSoc = (UILabel *)[cell viewWithTag:1];
        [cellRagSoc setText:es.RagioneSociale];
        
        
        CustomLabel *cellIndirizzo = (CustomLabel *)[cell viewWithTag:2];
        [cellIndirizzo setText:es.Indirizzo];
        [cellIndirizzo setLineHeight:10];
        [cellIndirizzo setVerticalAlignment:MSLabelVerticalAlignmentMiddle];
        UILabel *lblDistanza = (UILabel *)[cell viewWithTag:3];
        [lblDistanza setText:[NSString stringWithFormat:@"%.2f Km", es.distanza]];
        
        
        UIImageView *cellImage = (UIImageView *)[cell viewWithTag:4];
        
        if ([es.immagini count] >=1){
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
            dispatch_async(queue, ^{
            
              
                
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[es.immagini objectAtIndex:0]]];
                                                                      
            
                UIImage *img = [UIImage imageWithData:data];
            
            
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //offerta.Immagine = img;
                    cellImage.image = img;
                    [cellImage setNeedsLayout];
                });
            });
            
        }
        else{
        
            cellImage.image = nil;
        }
        
        UIView *cellBackView = [[UIView alloc] initWithFrame:CGRectZero];
        cellBackView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"sfondoCellAltriEsercenti.png"]];
        cell.backgroundView = cellBackView;
   
        
    }
    else if (indexPath.section==2){
    
    
        static NSString *CellIdentifier = @"altriRisultatiCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        
        UIButton  *btnCaricaAltri = (UIButton *)[cell viewWithTag:1];
        [btnCaricaAltri addTarget:self action:@selector(caricaAltriEsercentiWithIdentifier) forControlEvents:UIControlEventTouchUpInside];

        UILabel *cellCount = (UILabel *)[cell viewWithTag:2];
        [cellCount setText:[NSString stringWithFormat:@"Visibili %i risultati", [Esercenti count]]];

        UIView *cellBackView = [[UIView alloc] initWithFrame:CGRectZero];
        cellBackView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"sfondoCellAltriEsercenti.png"]];
        cell.backgroundView = cellBackView;
        
    }
    
    return cell;
}

- (void) hideGradientBackground:(UIView*)theView
{
    for (UIView * subview in theView.subviews)
    {
        if ([subview isKindOfClass:[UIImageView class]])
            subview.hidden = YES;
        
        [self hideGradientBackground:subview];
    }
}

-(void)caricaAltriEsercentiWithIdentifier
{
    
    //CLLocationCoordinate2D clloc = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).locationManager.location.coordinate;
    

    NSString *stringUrl=[NSString stringWithFormat: @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=%@&location=%f,%f&rankby=distance&types=food&sensor=false&key=%@",
                         nextPageToken,
                         cittaSelezionata.Coordinate.latitude,
                         cittaSelezionata.Coordinate.longitude,
                         GOOGLE_PLACES_KEY];
    
    [self Ricerca:stringUrl];
    
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"esercente"]) {
        
        
        // Get reference to the destination view controller
        EsercenteViewController *vc = [segue destinationViewController];
        
        // get the selected index
        NSInteger selectedIndex = [[self.myTable indexPathForSelectedRow] row];
        
        vc.esercenteSelezionato = [Esercenti objectAtIndex:selectedIndex];
    }
    else if ([[segue identifier] isEqualToString:@"offertaList"] ||
             [[segue identifier] isEqualToString:@"offertaMap"] ||
             [[segue identifier] isEqualToString:@"offertaLive"]){
    
        // Get reference to the destination view controller
        OffertaViewController *vc = [segue destinationViewController];
        
        // get the selected index
        NSInteger selectedIndex = [[self.myTable indexPathForSelectedRow] row];
        
        vc.offertaSelezionata = [Offerte objectAtIndex:selectedIndex];

    }
    
}



#pragma mark - Map view delegate

- (void)mapView:(MKMapView *)amapView didAddAnnotationViews:(NSArray *)views {
    for (MKAnnotationView *annotationView in views) {
        if (annotationView.annotation == amapView.userLocation) {
            MKCoordinateSpan span = MKCoordinateSpanMake(0.3, 0.3);
            MKCoordinateRegion region = MKCoordinateRegionMake(cittaSelezionata.Coordinate, span);
            [amapView setRegion:region animated:YES];
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)amapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
      static NSString *identifier = @"offertaAnnotation";
    
       if ([annotation isKindOfClass:[OffertaAnnotation class]] || [annotation isKindOfClass:[EsercenteAnnotation class]]){
        
         

        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [amapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
      //  annotationView.image=[UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
           
           if ([annotation isKindOfClass:[OffertaAnnotation class]])               
                [annotationView setPinColor:MKPinAnnotationColorGreen];
           
       
           [annotationView setRightCalloutAccessoryView:rightButton];
        return annotationView;
    }

    return nil;
}

-(void)mapView:(MKMapView *)aMapView didSelectAnnotationView:(MKAnnotationView *)view
{

    [NSObject cancelPreviousPerformRequestsWithTarget:self];    
    
    if (view.annotation != mapView.userLocation)
    {
         if ([view.annotation isKindOfClass:[OffertaAnnotation class]]) {
             OffertaAnnotation *of = (OffertaAnnotation *)view.annotation;
        
             [imgOffertaSelezionata setImage:of.offerta.Immagine];
             [lblTitoloOffertaSelezionata setText:[NSString stringWithFormat:@"%.2f anzichè %.2f EUR", of.offerta.PrezzoFinale, of.offerta.PrezzoPartenza]];
             [lblDescrizioneOffertaSelezionata setText:of.offerta.Titolo];
             [lblAcquistatiOffertaSelezionata setText:[NSString stringWithFormat:@"%i acquistati", of.offerta.CouponAcquistati]];
             [UIView animateWithDuration:0.5 animations:^{
                 vwOfferta.frame = CGRectMake(vwOfferta.frame.origin.x,
                                     self.view.frame.size.height - 100,
                                     vwOfferta.frame.size.width,
                                     100);
             }];
         }
    }
    
}

-(void)mapView:(MKMapView *)aMapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    [self performSelector:@selector(hideMyView) withObject:nil afterDelay:0.1];

      
}

-(void)hideMyView
{
    [UIView animateWithDuration:0.5 animations:^{
        vwOfferta.frame = CGRectMake(vwOfferta.frame.origin.x,
                                     self.view.frame.size.height,
                                     vwOfferta.frame.size.width,
                                     0);
    }];

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
      if ([view.annotation isKindOfClass:[OffertaAnnotation class]]) {
          OffertaAnnotation *of = (OffertaAnnotation *)view.annotation;
          
          OffertaViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"offertaVC"];
          [vc setOffertaSelezionata:of.offerta];    
          [self presentModalViewController:vc animated:YES];
      }
    else
    {
        EsercenteAnnotation *of = (EsercenteAnnotation *)view.annotation;
        
        EsercenteViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"esercenteVC"];
        [vc setEsercenteSelezionato:of.idEsercente];
        [self.navigationController pushViewController:vc animated:YES];

    }
}

@end
