//
//  OffertaViewController.m
//  liveDeal
//
//  Created by claudio barbera on 15/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "OffertaViewController.h"
#import "CustomLabel.h"
@interface OffertaViewController ()

@end

@implementation OffertaViewController
@synthesize offertaSelezionata, lblCountdown, share, btnAction, btnAcquista;



- (void)viewDidLoad
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){

        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        
        if(result.height == 1136){
            isIphone5=YES;
        }
    }

    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
   
    
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    share = [[GPPShare alloc] initWithClientID:@"GOOGLE_PLUS_KEY"];
    share.delegate = self;
    app.share = share;
    
    [myticker invalidate];
    myticker = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showActivity) userInfo:nil repeats:YES];

    int heigth=0;
    
    if (isIphone5)
    {
        heigth=460;
    }
    else
        heigth=374;
    
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, heigth)];
    [scroll setScrollEnabled:YES];
    [scroll setContentSize:CGSizeMake(320, 900)];
    [scroll setBackgroundColor:[UIColor colorWithRed:212.0f / 255 green:212.0f / 255 blue:212.0f / 255 alpha:1]];
   
    CustomLabel *lblTitolo = [[CustomLabel alloc] initWithFrame:CGRectMake(15, 15, 300, 90)];
    [lblTitolo setLineHeight:16];
    [lblTitolo setVerticalAlignment:MSLabelVerticalAlignmentTop];
    [lblTitolo setNumberOfLines:3];
    [lblTitolo setText:offertaSelezionata.Titolo];
    
    [lblTitolo setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
    [lblTitolo setTextColor:[UIColor colorWithRed:56.0f / 255 green:57.0f / 255 blue:59.0f / 255 alpha:1]];
    [lblTitolo setBackgroundColor:[UIColor clearColor]];
    
    [scroll addSubview:lblTitolo];
    
        
    UIImageView *imgBorder = [[UIImageView alloc] initWithFrame:CGRectMake(15, 80, 155, 127)];
    [scroll addSubview:imgBorder];
    
    UIImageView *imgd = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 150, 122)];
    [imgBorder addSubview:imgd];

    
      
       
    if (offertaSelezionata.Categoria.ColoreCornice != nil)
    {
        [imgd.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [imgd.layer setBorderWidth: 4.0];

        
        [imgBorder.layer setBorderColor:[offertaSelezionata.Categoria.ColoreCornice CGColor]];
        [imgBorder.layer setBorderWidth: 2.0];
    }

    
    if ([offertaSelezionata.immagini count]>=1)
    {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            
            NSString *url = [NSString stringWithFormat:@"http://www.specialdeal.it/crop/150x122/%@",[offertaSelezionata.immagini objectAtIndex:0]];
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
            
           img = [UIImage imageWithData:data];
            
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                // offerta.Immagine = img;
                imgd.image = img;
                [imgd setNeedsLayout];
            });
        });
    }
    
    UILabel *lblPrezzoFinale = [[UILabel alloc] initWithFrame:CGRectMake(180, 75, 140, 70)];
    [lblPrezzoFinale setBackgroundColor:[UIColor clearColor]];
    lblPrezzoFinale.opaque = NO;
    [lblPrezzoFinale setTextColor:[UIColor colorWithRed:225.0f / 255 green:77.0f / 255 blue:137.0f / 255 alpha:1]];
    [lblPrezzoFinale setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:36]];
    [lblPrezzoFinale setText:[NSString stringWithFormat:@"%.2f €", offertaSelezionata.PrezzoFinale]];
     [scroll addSubview:lblPrezzoFinale];
    
    UILabelStrikethrough *lblPrezzoPartenza = [[UILabelStrikethrough alloc] initWithFrame:CGRectMake(210, 125, 70, 30)];
    
    
    [lblPrezzoPartenza setText:[NSString stringWithFormat:@"€%.2f", offertaSelezionata.PrezzoPartenza]];
    [lblPrezzoPartenza setBackgroundColor:[UIColor clearColor]];
    [lblPrezzoPartenza setFont:[UIFont fontWithName:@"Helvetica Neue-Regular" size:18]];
    [lblPrezzoPartenza setTextColor:[UIColor colorWithRed:91.0f / 255
                                                    green:91.0f /
                                     255 blue:91.0f / 255
                                                    alpha:1]];
    [scroll addSubview:lblPrezzoPartenza];

    UIImageView *sep1 = [[UIImageView alloc] initWithFrame:CGRectMake(190, 160, 107, 59)];
    [sep1 setImage:[UIImage imageNamed:@"separatorOfferta.png"]];
    
    [scroll addSubview:sep1];


    UILabel *lblSconto = [[UILabel alloc] initWithFrame:CGRectMake(188, 160, 80, 50)];
    [lblSconto setText:[NSString stringWithFormat:@"%.0f%%", offertaSelezionata.Sconto]];
    [lblSconto setBackgroundColor:[UIColor clearColor]];
    [lblSconto setFont:[UIFont fontWithName:@"Helvetica Neue" size:20]];
    [lblSconto setTextColor:[UIColor colorWithRed:7.0f / 255
                                            green:0
                                             blue:0
                                            alpha:1]];
    [scroll addSubview:lblSconto];


    UILabel *lblIntestazioneSconto = [[UILabel alloc] initWithFrame:CGRectMake(185, 185, 80, 50)];
    [lblIntestazioneSconto setText:@"Sconto"];
    [lblIntestazioneSconto setBackgroundColor:[UIColor clearColor]];
    [lblIntestazioneSconto setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    [lblIntestazioneSconto setTextColor:[UIColor colorWithRed:162.0f / 255
                                                        green:162.0f / 255
                                                         blue:162.0f / 255
                                                        alpha:1]];
    
    [scroll addSubview:lblIntestazioneSconto];
    
    UILabel *lblAcquistati= [[UILabel alloc] initWithFrame:CGRectMake(270, 160, 80, 50)];
    [lblAcquistati setText:[NSString stringWithFormat:@"%i", offertaSelezionata.CouponAcquistati]];
    [lblAcquistati setBackgroundColor:[UIColor clearColor]];
    [lblAcquistati setFont:[UIFont fontWithName:@"Helvetica Neue" size:20]];
    [lblAcquistati setTextColor:[UIColor colorWithRed:7.0f / 255
                                                green:0
                                                 blue:0
                                                alpha:1]];
    [scroll addSubview:lblAcquistati];

    
    UILabel *lblIntestazioneAcquistati = [[UILabel alloc] initWithFrame:CGRectMake(255, 185, 80, 50)];
    [lblIntestazioneAcquistati setText:@"Acquistati"];
    [lblIntestazioneAcquistati setBackgroundColor:[UIColor clearColor]];
    [lblIntestazioneAcquistati setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    [lblIntestazioneAcquistati setTextColor:[UIColor colorWithRed:162.0f / 255
                                                            green:162.0f / 255
                                                             blue:162.0f / 255
                                                            alpha:1]];
    
    
    [scroll addSubview:lblIntestazioneAcquistati];

    
       
    UILabel *lblValidita = [[UILabel alloc] initWithFrame:CGRectMake(35, 214, 290, 50)];
   
    lblValidita.text = [Utility getValiditaWithDataInizio:offertaSelezionata.DataInizio
                                          andDataScadenza:offertaSelezionata.DataScadenza];
    
       [lblValidita setBackgroundColor:[UIColor clearColor]];
    [lblValidita setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
    [lblValidita setTextColor:[UIColor colorWithRed:108.0f / 255
                                              green:108.0f / 255
                                               blue:108.0f / 255
                                              alpha:1]];
    
    
    [scroll addSubview:lblValidita];
    
    UIImageView *imgTime = [[UIImageView alloc] initWithFrame:CGRectMake(15, 230, 15, 16)];
    [imgTime setImage:[UIImage imageNamed:@"iconTime2.png"]];
    [scroll addSubview:imgTime];
    

    
    UIImageView *sep3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 255, 314, 1)];
    [sep3 setImage:[UIImage imageNamed:@"separator.png"]];
    
    [scroll addSubview:sep3];
    
    UILabel *lblInBreve = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 50, 50)];
    [lblInBreve setText:@"In breve"];
    [lblInBreve setBackgroundColor:[UIColor clearColor]];
    [lblInBreve setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
    [lblInBreve setTextColor:[UIColor colorWithRed:56.0f / 255
                                             green:57.0f / 255
                                              blue:59.0f / 255
                                             alpha:1]];
    
    [scroll addSubview:lblInBreve];
    
    UIWebView *lblDescrizione = [[UIWebView alloc] initWithFrame:CGRectMake(10, 290, 300, 1000)];
    [lblDescrizione setDelegate:self];
    NSString *res = [NSString stringWithFormat:@"<div id='content'><font color='#38393b' size='1' face='Helvetica'>%@</font></div>", offertaSelezionata.Descrizione];
    
    [lblDescrizione loadHTMLString:res baseURL:nil];
    [lblDescrizione setBackgroundColor:[UIColor clearColor]];
    lblDescrizione.opaque = NO;
    lblDescrizione.backgroundColor = [UIColor clearColor];
    [Utility hideGradientBackground:lblDescrizione];
    [lblDescrizione.scrollView setScrollEnabled:NO];
    [scroll addSubview:lblDescrizione];
    
      
    [self.view addSubview:scroll];
    
    
}

-(void)didSelect:(id)object andIdentifier:(NSString *)identifier
{
    NSString *status = (NSString *)object;
    
    if ([status isEqualToString:@"OK"])
    {
         UIAlertView *alertView = [[UIAlertView alloc]
                                    initWithTitle:@"Ok"
                                    message:@"Post inserito correttamente"
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
            [alertView show];
    }
    
    [hud setHidden:YES];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView

{
    int h = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] intValue];
     
    [scroll setContentSize:CGSizeMake(320,  h + 330)];
    
    
}



- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}


-(void)didAutenticate
{
    if ([offertaSelezionata.Subdeals count] >=1)
        [self performSegueWithIdentifier:@"subdeals" sender:self];
    else
        [self performSegueWithIdentifier:@"pagamento" sender:self];

}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            [self postUpdate];
                        break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            
                       
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


-(void)shareFb{

    [self openSession];
}

- (void)postUpdate{
    
    NSURL *url = [NSURL URLWithString:offertaSelezionata.Url];
    NSString *title = @"Dai un'occhiata a questo deal";

     BOOL displayedNativeDialog =
    [FBNativeDialogs
     presentShareDialogModallyFrom:self
     initialText:title
     image:nil
     url: url
        handler:^(FBNativeDialogResult res, NSError *error) {
         if (error) {
             /* handle failure */
             NSLog(@"error:%@, %@", error, [error localizedDescription]);
         } else {
             if (res == FBNativeDialogResultSucceeded) {
                 /* handle success */
                                NSLog(@"handle success");
             } else {
                 /* handle user cancel */
                 NSLog(@"user cancel");
             }
         }
     }];
    if (!displayedNativeDialog) {

        
        PostToFbViewController *b= [self.storyboard instantiateViewControllerWithIdentifier:@"postToFb"];
        b.url = offertaSelezionata.Url;
        b.titolo = title;
        b.img  = img;
        b.delegate = self;
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Attendere";

        [self presentModalViewController:b animated:YES];

    }
}


// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = error.localizedDescription;
        alertTitle = @"Error";
    } else {
        //NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = @"Ok";
        alertTitle = @"Ok";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}
-(void)shareTwitter{

    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetVC = [[TWTweetComposeViewController alloc] init];
        [tweetVC setInitialText:offertaSelezionata.Titolo];
         [tweetVC addImage:imgDeal];
        [tweetVC addURL:[NSURL URLWithString:offertaSelezionata.Url]];
       
        [self presentModalViewController:tweetVC animated:YES];
    }
    else
    { UIAlertView *alertView = [[UIAlertView alloc]
                                initWithTitle:@"Sorry"
                                message:@"Non puoi mandare un tweet adesso. Assicurati che il tuo device abbia una connessione dati e che tu abbia almeno un account Twitter"
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [alertView show];
    }
}
-(void)shareGp{

    NSURL *url = [NSURL URLWithString:offertaSelezionata.Url];
    NSString *titolo = offertaSelezionata.Titolo;
    
    [[[[share shareDialog]
       setURLToShare:url]
      setPrefillText:titolo] open];
    
    // Or, without a URL or prefill text:
    [[share shareDialog] open];
    
}

-(void)finishedSharing:(BOOL)shared
{
    NSString *titolo;
    NSString *messaggio;
    
    if (shared)
    {
        titolo = @"Ok";
        messaggio=@"Ok";
      
    }
    else
    {
        titolo = @"Ko";
        messaggio=@"Ko";
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titolo message:messaggio delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)showActivity {
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *currentDate = [dateformatter dateFromString:offertaSelezionata.DataScadenza];
    
     today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:today toDate:currentDate options:0];
    lblCountdown.text = [NSString stringWithFormat:@"%02d giorni, %02d:%02d:%02d", components.day, components.hour, components.minute, components.second ];
    
    if (components.day<=0 && components.hour<=0 && components.minute <=0 && components.second <=0)
    {
        [myticker invalidate];
        lblCountdown.text=@"Offerta scaduta";
        [btnAcquista setHidden:YES];
        
        
    }

}

-(IBAction)vaiAPagamento:(id)sender
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *tokenAccess = [defaults objectForKey:@"token_access"];
    
    User *u = [Utility UserFromToken:tokenAccess];
    
    if (!u)
    {
    
        UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
        LoginViewController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
        loginController.loginDelegate = self;
       
        [loginController setShowBackButton:YES];
        
        [self.navigationController pushViewController:loginController animated:NO];



    }
    else{
    
        if ([offertaSelezionata.Subdeals count] >= 1)
        {
            [self performSegueWithIdentifier:@"subdeals" sender:self];  
        }
        else
            [self performSegueWithIdentifier:@"pagamento" sender:self];
        
    }
       
}

-(IBAction)showActionSheet:(id)sender{

 UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"fb",@"twitter",@"gpp", nil];
    
    [popupQuery showFromBarButtonItem:btnAction animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self shareFb];
            break;
        case 1:
            [self shareTwitter];
            break;
        case 2:
            [self shareGp];
            break;
        default:
            break;
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIButton *btn in [actionSheet valueForKey:@"_buttons"])
    {
        if ([btn.currentTitle isEqualToString:@"fb"]){
            [btn setBackgroundImage:[UIImage imageNamed:@"fb.png"]     forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"fb.png"]     forState:UIControlStateHighlighted];
            [btn  setTitle:@"" forState:UIControlStateNormal];
            [btn  setTitle:@"" forState:UIControlStateHighlighted];

        }
        else if ([btn.currentTitle isEqualToString:@"twitter"]){
            [btn setBackgroundImage:[UIImage imageNamed:@"tweet.png"]     forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"tweet.png"]     forState:UIControlStateHighlighted];
            [btn  setTitle:@"" forState:UIControlStateNormal];
            [btn  setTitle:@"" forState:UIControlStateHighlighted];

        }
        else if ([btn.currentTitle isEqualToString:@"gpp"]){
            [btn setBackgroundImage:[UIImage imageNamed:@"shareGp@2x.png"]     forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"shareGp@2x.png"]     forState:UIControlStateHighlighted];
            [btn  setTitle:@"" forState:UIControlStateNormal];
            [btn  setTitle:@"" forState:UIControlStateHighlighted];

        }
        
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"subdeals"]){
    
        SubdealsViewController *vc = [segue destinationViewController];
        vc.offertaSelezionata = offertaSelezionata;
    }
    // Make sure we're referring to the correct segue
    else if ([[segue identifier] isEqualToString:@"pagamento"]) {
        
        
        // Get reference to the destination view controller
        PagamentoViewController *vc = [segue destinationViewController];
        
        // get the selected index
        vc.offertaSelezionata = offertaSelezionata;
    }    
}
@end
