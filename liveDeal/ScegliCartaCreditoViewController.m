//
//  ScegliCartaCreditoViewController.m
//  liveDeal
//
//  Created by claudio barbera on 08/01/13.
//  Copyright (c) 2013 claudio barbera. All rights reserved.
//

#import "ScegliCartaCreditoViewController.h"

@interface ScegliCartaCreditoViewController ()

@end

@implementation ScegliCartaCreditoViewController
@synthesize elencoCarte, delegate, chiavePagamento, offertaSelezionata;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(paymentNotification:)
                                                 name:@"pagamentoNotificato"
                                               object:nil];
    
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath* selectedCellIndexPath=nil;
    
    if ([elencoCarte count] >= 1)
       selectedCellIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
    else
       selectedCellIndexPath= [NSIndexPath indexPathForRow:0 inSection:1];
    
      [self tableView:self.tableView didSelectRowAtIndexPath:selectedCellIndexPath];
}

-(void )paymentNotification:(NSNotification *)notification
{
    NSString *r = notification.object;
    
    if ([r isEqualToString:@"PAID"])
        [self performSegueWithIdentifier:@"pagamentoOk" sender:self];
    else{
        [self.delegate didSelect:@"Messaggio da impostare" andIdentifier:@"errorePagamento"];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
      
}

-(void) viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.delegate didSelect:nil andIdentifier:@"annullaPagamento"];
    }
    [super viewWillDisappear:animated];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pagamentoOk"])
    {
        SuccessViewController *s = [segue destinationViewController];
        s.offertaSelezionata = offertaSelezionata;
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
        return [elencoCarte count] ; 
    else
       return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if ([indexPath section]==0)
    {
        
        static NSString *CellIdentifier = @"cc";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CreditCard *card = [elencoCarte objectAtIndex:indexPath.row];

        UILabel *lblDescrizione = (UILabel *)[cell viewWithTag:1];
        UILabel *lblTipoCarta= (UILabel *)[cell viewWithTag:2];
        UILabel *lblScadenza= (UILabel *)[cell viewWithTag:3];
        
        [lblDescrizione setText:card.description_card];
        [lblTipoCarta setText:card.description_cardtype];
        [lblScadenza setText:card.description_cardexpiry];
        
    }
    else
    {
        static NSString *CellIdentifier = @"nuovacc";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }    }
        
    return cell;

}


-(void)paga
{
    NSString *url=[NSString stringWithFormat:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/constriv_pay?token_access=%@&payment_key=%@&card_id=%d", [[NSUserDefaults standardUserDefaults] objectForKey:@"token_access"], chiavePagamento, cardId];
   
   
    [self Ricerca:url];

    
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
        return 80;
    else return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1)
        return 50;
    else return 10;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ((section==1) && elencoCarte.count ==0)
        return @"";
    
    if (section==0)
        return @"Utilizza una carta memorizzata";
    else
        return @"Utilizza una nuova carta di credito";
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==1)
    {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
        
        
        
        UIButton *btnPaga = [[UIButton alloc] initWithFrame:CGRectMake(40, 17, 251, 31)];
        [btnPaga setTitle:@"Effettua pagamento" forState:UIControlStateNormal];
        
        
        [btnPaga setBackgroundImage:[UIImage imageNamed:@"sfondoPulsantePaga.png"] forState:UIControlStateNormal];
        
        [btnPaga addTarget:self action:@selector(paga) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [footer addSubview:btnPaga];
        
        return  footer;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (newCell.accessoryType == UITableViewCellAccessoryNone)
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
         newCell.accessoryType = UITableViewCellAccessoryNone;
    
    UITableViewCell *oldcell = [tableView cellForRowAtIndexPath:old];
   
    if (oldcell.accessoryType == UITableViewCellAccessoryNone)
        oldcell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        oldcell.accessoryType = UITableViewCellAccessoryNone;

   
    old = indexPath;

    if (indexPath.section==0)
        cardId = [[elencoCarte objectAtIndex:indexPath.row] Id];
    else
        cardId= -1;

}

#pragma mark Connection delegates

-(void)Ricerca:(NSString *)searchText
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:searchText]  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                     timeoutInterval:60.0];
    
    
    NSURLConnection *myConn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (myConn)
    {
        tempArray = [[NSMutableData alloc] init];
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Attendere...";
        
    }
    else{
        
        [self.delegate didSelect:nil andIdentifier:@"annullaPagamento"];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

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
    
    
           
    NSDictionary *result = [json valueForKeyPath:@"result"];
    
    if (result!=nil)
    {
        //l'api ha dato esito positivo
        
        if (cardId <=0){
        
            //utente ha deciso di inserire una nuova carta. Nella risposta riceviamo l'url al quale fare il redirect
          
            NSURL *url = [NSURL URLWithString:[result objectForKey:@"redirect"]];
            [[UIApplication sharedApplication] openURL:url];

        }
        else
        {
            //l'utente sta utilizzando una carta preesistente. Nella risposta trovo lo stato del pagamento
            BOOL paid = [[result objectForKey:@"paid"] boolValue];
            
            if (paid)
            {
                [self performSegueWithIdentifier:@"pagamentoOk" sender:self];
            }
            else
            {
                
                [self.delegate didSelect:@"Errore" andIdentifier:@"errorePagamento"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
       
    }
    else
    {
         NSDictionary *error = [json valueForKey:@"error"];
        
        [self.delegate didSelect:[error objectForKey:@"message"] andIdentifier:@"errorePagamento"];
        [self.navigationController popViewControllerAnimated:YES];

        
       

        
       // pagamentoGiaAnnullato = true;
    }
    
    
    [hud hide:YES];
    
    
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    
    [self.delegate didSelect:@"Impossibile completare il pagamento. Connessione assente" andIdentifier:@"annullaPagamento"];
    [self.navigationController popViewControllerAnimated:YES];

    
}

@end
