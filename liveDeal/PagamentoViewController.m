//
//  PagamentoViewController.m
//  liveDeal
//
//  Created by claudio barbera on 29/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "PagamentoViewController.h"
#define MAX_NUMBER_OF_COUPON 30

#import "PayPalPayment.h"
#import "PayPalAdvancedPayment.h"
#import "PayPalAmounts.h"
#import "PayPalReceiverAmounts.h"
#import "PayPalAddress.h"
#import "PayPalInvoiceItem.h"

@interface PagamentoViewController ()

@end

@implementation PagamentoViewController
@synthesize img, lblTitolo, lblRagioneSociale, offertaSelezionata, lblValidita, lblQta, lblTot, btnPaga, imgCell, lblCC, imgPaypal, imgBorder, navBar, paypalButton, loginController, elencoCarte, opzioneSelezionata;






- (void)viewDidLoad
{
     
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   

    
    paypalButton = [[PayPal getPayPalInst] getPayButtonWithTarget:self andAction:@selector(eseguiPagamentoPayPal) andButtonType:BUTTON_294x43];
    
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        
        if(result.height == 1136){
            isIphone5=YES;
        }
    }

    int heigth=0;
    
    if (isIphone5)
    {
        heigth=349 + 92;
    }
    else
        heigth=349;
    

    
	CGRect frame = paypalButton.frame;
	frame.origin.x = round((self.view.frame.size.width - paypalButton.frame.size.width) / 2.);
	frame.origin.y = heigth; // + 176
	paypalButton.frame = frame;
	[self.view addSubview:paypalButton];
    [self.paypalButton setHidden:YES];
    [self.btnPaga setHidden:NO];
    [imgPaypal setHidden:YES];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sfondoDetail.png"]]];
   

    
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSceltaPagamento)];
    
    [imgCell addGestureRecognizer:tapRecognize];
    
    
    [lblTitolo setLineHeight:20];
    [lblTitolo setVerticalAlignment:MSLabelVerticalAlignmentTop];
    [lblTitolo setText:offertaSelezionata.Titolo];
    
    [lblTitolo setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [lblTitolo setTextColor:[UIColor colorWithRed:56.0f / 255 green:57.0f / 255 blue:59.0f / 255 alpha:1]];
    [lblTitolo setBackgroundColor:[UIColor clearColor]];
    
    [lblRagioneSociale setText:offertaSelezionata.Esercente.RagioneSociale];
    
    [lblValidita setText:offertaSelezionata.Validita];
    
    
    [lblQta setFont:[UIFont fontWithName:@"Bebas Neue" size:26]];
    [lblQta setTextColor:[UIColor colorWithRed:78.0f / 255 green:47.0f / 255 blue:13.0f / 255 alpha:1]];
    [lblQta setBackgroundColor:[UIColor clearColor]];
    
    [lblTot setFont:[UIFont fontWithName:@"Bebas Neue" size:26]];
    [lblTot setTextColor:[UIColor colorWithRed:225.0f / 255 green:77.0f / 255 blue:137.0f / 255 alpha:1]];
    [lblTot setBackgroundColor:[UIColor clearColor]];


    [self aggiornaTotaleWithQuantita:1];
    
    
    if (offertaSelezionata.Categoria.ColoreCornice != nil)
    {
        [img.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [img.layer setBorderWidth: 4.0];
        
        
        [imgBorder.layer setBorderColor:[offertaSelezionata.Categoria.ColoreCornice CGColor]];
        [imgBorder.layer setBorderWidth: 2.0];
    }
    
    if ([offertaSelezionata.immagini count]>=1)
    {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            
            NSString *url = [NSString stringWithFormat:@"http://www.specialdeal.it/crop/150x122/%@",[offertaSelezionata.immagini objectAtIndex:0]];
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
            
            UIImage *imgT = [UIImage imageWithData:data];
            
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                // offerta.Immagine = img;
                img.image = imgT;
                [img setNeedsLayout];
            });
        });
    }

    

}

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
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}


-(void)eseguiPagamentoPayPal
{
 
    gateway = PayPalIPN;
    [self richiamaApiPagamentoConTipo];
}

-(void)richiamaApiPagamentoConTipo
{
    tipo = STARTPAY;
    
    NSString *chiaveGateway;
    
    if (gateway== PayPalIPN)
        chiaveGateway=@"PayPalIPN";
    else
        chiaveGateway=@"ConsTriv";
    
    NSString *url=@"";
    if (!opzioneSelezionata)
        url=[NSString stringWithFormat:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/start_pay?token_access=%@&deal_id=%d&gateway=%@&quantity=%d", [[NSUserDefaults standardUserDefaults] objectForKey:@"token_access"], offertaSelezionata.Id, chiaveGateway, [lblQta.text integerValue]];
    else
        url=[NSString stringWithFormat:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/start_pay?token_access=%@&deal_id=%d&gateway=%@&quantity=%d&sub_deal_id=%d", [[NSUserDefaults standardUserDefaults] objectForKey:@"token_access"], offertaSelezionata.Id, chiaveGateway, [lblQta.text integerValue], opzioneSelezionata.Id];

    [self Ricerca:url];

}

-(void)didSelect:(id)object andIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:@"annullaPagamento"])
    {
        //viene richiamato per annullare il pagamento. Se viene impostato object rappresenta una stringa con un messaggio d'errore. lo mostro
        
        if (object!=nil)
        {
            NSString *errmsg = (NSString *)object;
            UIAlertView *ui = [[UIAlertView alloc] initWithTitle:@"Ops" message:errmsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [ui show];
        }
        
        [self annullaPagamento];
    }
    else if ([identifier isEqualToString:@"errorePagamento"])
    {
        
        //viene richiamato per dare un messaggio all'utente. Il pagamento è stato già annullato dalla chiamata all'api. dentro object trovo il messaggio d'errore, lo mostro
        NSString *errmsg = (NSString *)object;
        UIAlertView *ui = [[UIAlertView alloc] initWithTitle:@"Ops" message:errmsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [ui show];
    }
    else if ([object isEqualToString:@"CC"])
    {
        [self.btnPaga setHidden:NO];
        [self.paypalButton setHidden:YES];
        [lblCC setHidden:NO];
        [imgPaypal setHidden:YES];
    }
    else
    {
        [self.btnPaga setHidden:YES];
        [self.paypalButton setHidden:NO];
        [lblCC setHidden:YES];
        [imgPaypal setHidden:NO];
    }
    
    [hud hide:YES];
}

-(void)openSceltaPagamento
{
    [self performSegueWithIdentifier:@"sceltaPagamento" sender:self];
}

- (IBAction)incrementa:(id)sender{

    int count = [lblQta.text integerValue];
    
    if (count<MAX_NUMBER_OF_COUPON){
        lblQta.text = [NSString stringWithFormat:@"%i", ++count];
        [self aggiornaTotaleWithQuantita:count];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"success"])
    {
        SuccessViewController *s = [segue destinationViewController];
        s.offertaSelezionata = offertaSelezionata;
    }
    else if ([[segue identifier] isEqualToString:@"creditCard"])
    {
        ScegliCartaCreditoViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.offertaSelezionata = offertaSelezionata;
        vc.chiavePagamento = chiavePagamento;
        vc.elencoCarte = elencoCarte;
    }
    else
    {
        
        ScegliPagamentoViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
}
    

- (IBAction)decrementa:(id)sender{

    int count = [lblQta.text integerValue];
    
    if (count>1){
        lblQta.text = [NSString stringWithFormat:@"%i", --count];
        [self aggiornaTotaleWithQuantita:count];
    }
}

-(IBAction)paga:(id)sender
{
    //richiamo l'api per il pagamento passando ConsTriv
    gateway = ConsTriv;
    [self richiamaApiPagamentoConTipo];
}

-(void)aggiornaTotaleWithQuantita:(int)quantita
{
    if (!opzioneSelezionata)
        tot = offertaSelezionata.PrezzoFinale * quantita;
    else
        tot = opzioneSelezionata.PrezzoFinale * quantita;
    
    [lblTot setText:[NSString stringWithFormat:@"%.2f €",tot]];
    [btnPaga setTitle:[NSString stringWithFormat:@"Acquista  %.2f €", tot] forState:UIControlStateNormal];
}



- (void)doPayPalPayment {
	   
  
	//optional, set shippingEnabled to TRUE if you want to display shipping
	//options to the user, default: TRUE
	[PayPal getPayPalInst].shippingEnabled = TRUE;
	
	//optional, set dynamicAmountUpdateEnabled to TRUE if you want to compute
	//shipping and tax based on the user's address choice, default: FALSE
	[PayPal getPayPalInst].dynamicAmountUpdateEnabled = FALSE;
	
	//optional, choose who pays the fee, default: FEEPAYER_EACHRECEIVER
	[PayPal getPayPalInst].feePayer = FEEPAYER_EACHRECEIVER;
	
	//for a payment with a single recipient, use a PayPalPayment object
	PayPalPayment *payment = [[PayPalPayment alloc] init] ;
	payment.recipient =    @"info@specialdeal.it";
	payment.paymentCurrency = @"EUR";
	payment.description = offertaSelezionata.Titolo;
	payment.merchantName = @"Special Deal";
		//subtotal of all items, without tax and shipping
	payment.subTotal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", tot]];
	
       [payment setIpnUrl:ipnUrl];
	
    //invoiceData is a PayPalInvoiceData object which contains tax, shipping, and a list of PayPalInvoiceItem objects
	payment.invoiceData = [[PayPalInvoiceData alloc] init];
	payment.invoiceData.totalShipping = [NSDecimalNumber decimalNumberWithString:@"0"];
	payment.invoiceData.totalTax = [NSDecimalNumber decimalNumberWithString:@"0"];
	
	//invoiceItems is a list of PayPalInvoiceItem objects
	//NOTE: sum of totalPrice for all items must equal payment.subTotal
	//NOTE: example only shows a single item, but you can have more than one
	payment.invoiceData.invoiceItems = [NSMutableArray array];
	PayPalInvoiceItem *item = [[PayPalInvoiceItem alloc] init];
	item.totalPrice = payment.subTotal;
	item.name = [NSString stringWithFormat:@"DealId: %d", offertaSelezionata.Id];
	[payment.invoiceData.invoiceItems addObject:item];
	
	[[PayPal getPayPalInst] checkoutWithPayment:payment];
}


#pragma mark -
#pragma mark PayPalPaymentDelegate methods

-(void)RetryInitialization
{
    [PayPal initializeWithAppID:PAYPAL_KEY forEnvironment:PAYPAL_ENVIRONMENT];
    
    //DEVPACKAGE
    //	[PayPal initializeWithAppID:@"your live app id" forEnvironment:ENV_LIVE];
    //	[PayPal initializeWithAppID:@"anything" forEnvironment:ENV_NONE];
}

//paymentSuccessWithKey:andStatus: is a required method. in it, you should record that the payment
//was successful and perform any desired bookkeeping. you should not do any user interface updates.
//payKey is a string which uniquely identifies the transaction.
//paymentStatus is an enum value which can be STATUS_COMPLETED, STATUS_CREATED, or STATUS_OTHER
- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus {
    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
	NSLog(@"severity: %@", severity);
	NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
	NSLog(@"category: %@", category);
	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
	NSLog(@"errorId: %@", errorId);
	NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
	NSLog(@"message: %@", message);
    
	status = PAYMENTSTATUS_SUCCESS;
}

//paymentFailedWithCorrelationID is a required method. in it, you should
//record that the payment failed and perform any desired bookkeeping. you should not do any user interface updates.
//correlationID is a string which uniquely identifies the failed transaction, should you need to contact PayPal.
//errorCode is generally (but not always) a numerical code associated with the error.
//errorMessage is a human-readable string describing the error that occurred.
- (void)paymentFailedWithCorrelationID:(NSString *)correlationID {
    
    [self annullaPagamento];
    
    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
	NSLog(@"severity: %@", severity);
	NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
	NSLog(@"category: %@", category);
	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
	NSLog(@"errorId: %@", errorId);
	NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
	NSLog(@"message: %@", message);
    
	status = PAYMENTSTATUS_FAILED;
}

//paymentCanceled is a required method. in it, you should record that the payment was canceled by
//the user and perform any desired bookkeeping. you should not do any user interface updates.
- (void)paymentCanceled {
    
    [self annullaPagamento];
	status = PAYMENTSTATUS_CANCELED;
}

-(void)annullaPagamento
{
    
      
    NSString *url=[NSString stringWithFormat:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/cancel_payment?token_access=%@&payment_key=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token_access"], chiavePagamento];
    
    
    tipo = CANCELPAY;
    
    [self Ricerca:url];
       
}


//paymentLibraryExit is a required method. this is called when the library is finished with the display
//and is returning control back to your app. you should now do any user interface updates such as
//displaying a success/failure/canceled message.
- (void)paymentLibraryExit {
	UIAlertView *alert = nil;
     
	switch (status) {
		case PAYMENTSTATUS_SUCCESS:
                [self performSegueWithIdentifier:@"success" sender:self];
           	break;
		case PAYMENTSTATUS_FAILED:
			alert = [[UIAlertView alloc] initWithTitle:@"Ops.."
											   message:@"Si è verificato un errore durante il pagamento."
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
		case PAYMENTSTATUS_CANCELED:
            break;
	}
    
    if (!alert)
        [alert show];
}


//adjustAmountsForAddress:andCurrency:andAmount:andTax:andShipping:andErrorCode: is optional. you only need to
//provide this method if you wish to recompute tax or shipping when the user changes his/her shipping address.
//for this method to be called, you must enable shipping and dynamic amount calculation on the PayPal object.
//the library will try to use the advanced version first, but will use this one if that one is not implemented.
- (PayPalAmounts *)adjustAmountsForAddress:(PayPalAddress const *)inAddress andCurrency:(NSString const *)inCurrency andAmount:(NSDecimalNumber const *)inAmount
									andTax:(NSDecimalNumber const *)inTax andShipping:(NSDecimalNumber const *)inShipping andErrorCode:(PayPalAmountErrorCode *)outErrorCode {
	//do any logic here that would adjust the amount based on the shipping address
	PayPalAmounts *newAmounts = [[PayPalAmounts alloc] init];
	newAmounts.currency = @"EUR";
	newAmounts.payment_amount = (NSDecimalNumber *)inAmount;
	

	newAmounts.shipping = (NSDecimalNumber *)inShipping;
	
	//if you need to notify the library of an error condition, do one of the following
	//*outErrorCode = AMOUNT_ERROR_SERVER;
	//*outErrorCode = AMOUNT_CANCEL_TXN;
	//*outErrorCode = AMOUNT_ERROR_OTHER;
    
	return newAmounts;
}

//adjustAmountsAdvancedForAddress:andCurrency:andReceiverAmounts:andErrorCode: is optional. you only need to
//provide this method if you wish to recompute tax or shipping when the user changes his/her shipping address.
//for this method to be called, you must enable shipping and dynamic amount calculation on the PayPal object.
//the library will try to use this version first, but will use the simple one if this one is not implemented.
- (NSMutableArray *)adjustAmountsAdvancedForAddress:(PayPalAddress const *)inAddress andCurrency:(NSString const *)inCurrency
								 andReceiverAmounts:(NSMutableArray *)receiverAmounts andErrorCode:(PayPalAmountErrorCode *)outErrorCode {
	NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:[receiverAmounts count]];
	
	
	return returnArray;
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
    
    
    if (tipo==STARTPAY){
    
        NSDictionary *result = [json valueForKeyPath:@"result"];
        
        if (result!=nil)
        {
            chiavePagamento = [result objectForKey:@"payment_key"];

            
            if (gateway==PayPalIPN){
                 ipnUrl = [result objectForKey:@"ipn_url"];
                [self doPayPalPayment];
            }
            else
            {
                if (![[result objectForKey:@"cards"] isKindOfClass: [NSNull class]])
                {
                     elencoCarte = [[NSMutableArray alloc] init];
                    NSArray *cards = [result objectForKey:@"cards"];
                    
                    for (NSDictionary *card in cards)
                    {
                        CreditCard *c = [[CreditCard alloc] init];
                        [c setId:[[card objectForKey:@"id"] integerValue]];
                        [c setCardtype:[card objectForKey:@"cardtype"]];
                        [c setExpdate:[card objectForKey:@"expdate"]];
                        [c setCardlastfourdigits:[card objectForKey:@"cardlastfourdigits"]];
                        [c setDescription_card:[card objectForKey:@"description_card"]];
                        [c setDescription_cardtype:[card objectForKey:@"description_cardtype"]];
                        [c setDescription_cardexpiry:[card objectForKey:@"description_cardexpiry"]];
                        
                        [elencoCarte addObject:c];
                        
                    }
                }
               
                
                [self performSegueWithIdentifier:@"creditCard" sender:nil];
            }
        }
        else
        {
            NSDictionary *error = [json valueForKey:@"error"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:[error objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        

    }
    else if (tipo==CANCELPAY)
    {
        NSDictionary *result = [json valueForKeyPath:@"result"];
        
        if (result==nil)
        {
            NSDictionary *error = [json valueForKey:@"error"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:[error objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }
    
   [hud hide:YES];
    
    
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

@end
