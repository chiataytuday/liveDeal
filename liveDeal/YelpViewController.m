//
//  YelpViewController.m
//  liveDeal
//
//  Created by claudio barbera on 08/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "YelpViewController.h"


@interface YelpViewController ()

@end

@implementation YelpViewController
@synthesize Esercenti;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CLLocationCoordinate2D clloc = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).locationManager.location.coordinate;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.yelp.com/v2/search?category_filter=beautysvc&lang=it&ll=%f,%f", clloc.latitude, clloc.longitude]];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"mzlkw0YCxjqIW3xFo-V5jQ" secret:@"bOTqgHzAcnV6RsjPqNoSqRTQ9u8"];
    OAToken *token = [[OAToken alloc] initWithKey:@"laNgdECwK2ULXKr7GlsnaPPOylgAhpNA" secret:@"qRUKmhu6_NWg8IWifyPHkBOTlwo"];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    [request prepare];
    
   
   // [self prepare];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
  //  NSURLConnection *myConn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (connection)
    {
         _responseData = [[NSMutableData alloc] init];
        Esercenti = [[NSMutableArray alloc] init];
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"Caricamento dati...";
        
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
  
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@, %@", [error localizedDescription], [error localizedFailureReason]);
  }

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:_responseData //1
                     options:kNilOptions error:nil];
    
    
    NSArray *items = [json valueForKeyPath:@"businesses"];
    
    
    
    for (NSDictionary *esercenti in items)
    {
        
        NSDictionary *region = [esercenti valueForKey:@"region"];
        NSDictionary *center = [region valueForKey:@"center"];
        
        NSDictionary *location = [esercenti valueForKey:@"location"];
        
        NSArray *address = [location valueForKey:@"address"];
        
        double lat = [[center valueForKey:@"latitude"] doubleValue];
        double lng = [[center valueForKey: @"longitude"] doubleValue];

        
        NSString *addressString = @"";
        if ([address count] >= 1)
            addressString = [address objectAtIndex:0];
        
        Esercente *e = [[Esercente alloc] initWithRagioneSociale:[esercenti valueForKey:@"name"]
                                                          Codice:[esercenti valueForKey:@"id"]
                                                        immagine:[esercenti valueForKey:@"image_url"]
                                                       Indirizzo:addressString
                                                      Coordinate:CLLocationCoordinate2DMake(lat, lng)];
        
        [Esercenti addObject:e];
    }
    
    [hud hide:YES];
    [self.tableView reloadData];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Esercenti count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"esercenteCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Esercente *es = [Esercenti objectAtIndex:indexPath.row];
    
    UILabel *cellRagSoc = (UILabel *)[cell viewWithTag:1];
    [cellRagSoc setText:es.RagioneSociale];
    
    
    UILabel *cellIndirizzo = (UILabel *)[cell viewWithTag:2];
    [cellIndirizzo setText:es.Indirizzo];
    
    
    UIImageView *cellImage = (UIImageView *)[cell viewWithTag:3];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:es.Immagine]];
        
        UIImage *img = [UIImage imageWithData:data];
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            //offerta.Immagine = img;
            cellImage.image = img;
            [cellImage setNeedsLayout];
        });
    });
    
    return cell;
}

@end
