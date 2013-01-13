//
//  EsercentiPreferitiViewController.m
//  liveDeal
//
//  Created by claudio barbera on 25/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "EsercentiPreferitiViewController.h"

@interface EsercentiPreferitiViewController ()

@end

@implementation EsercentiPreferitiViewController
@synthesize fetchedResultsController, esercentiPreferiti;


-(NSFetchedResultsController *)fetchedResultsController{
    
    if (fetchedResultsController!=nil)
    {
        return fetchedResultsController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EsercenteST"
                                              inManagedObjectContext:context];
    
    
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"codice" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSFetchedResultsController *aFetch = [[NSFetchedResultsController alloc]
                                          initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:@"Root"];
    
    [aFetch setDelegate:self];
    self.fetchedResultsController = aFetch;
    
    
    return fetchedResultsController;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];

    
    NSError *err;
    
    if (![self.fetchedResultsController performFetch:&err]){
        NSLog(@"Errore");
    }
   
    
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return [[fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[[fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"esercenteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    

    EsercenteST *es = [fetchedResultsController objectAtIndexPath:indexPath];
    
    UILabel *cellRagSoc = (UILabel *)[cell viewWithTag:1];
    [cellRagSoc setText:es.ragioneSociale];
    
    
    CustomLabel *cellIndirizzo = (CustomLabel *)[cell viewWithTag:2];
    [cellIndirizzo setText:es.indirizzo];
    [cellIndirizzo setLineHeight:10];
    [cellIndirizzo setVerticalAlignment:MSLabelVerticalAlignmentMiddle];
    UILabel *lblDistanza = (UILabel *)[cell viewWithTag:3];
    [lblDistanza setText:[NSString stringWithFormat:@"%.2f Km", [es.distance doubleValue]]];
    
    
    UIImageView *cellImage = (UIImageView *)[cell viewWithTag:4];
    
    if (es.immagine != nil){
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            
            
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:es.immagine]];
            
            
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

    
    
    return cell;}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      return 80;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        
        NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
        EsercenteST *rst = [fetchedResultsController objectAtIndexPath:indexPath];
        
        [context deleteObject:rst];
        NSError *err;
        
        if (![context save:&err])
        {
            NSLog(@"Errore");
            
        }
        
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type == NSFetchedResultsChangeDelete) {
        // Delete row from tableView.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                            withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (type== NSFetchedResultsChangeInsert){
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                            withRowAnimation:UITableViewRowAnimationRight];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EsercenteAggiunto" object:self];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get reference to the destination view controller
    EsercenteViewController *vc = [segue destinationViewController];
    
    NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];    
    EsercenteST *rst = [fetchedResultsController objectAtIndexPath:selectedIndex];
      
    Esercente *es = [[Esercente alloc] init];
    es.RagioneSociale = rst.ragioneSociale;
    es.Codice = rst.codice;
    es.Indirizzo = rst.indirizzo;
    es.Coordinate =CLLocationCoordinate2DMake([rst.latitude doubleValue], [rst.longitude doubleValue]);
    
    NSMutableArray *img = [[NSMutableArray alloc] initWithCapacity:1];
    [img addObject:rst.immagine];
    
    es.immagini = img;
    
    vc.esercenteSelezionato = es;
    
}
@end
