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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    AppDelegate *app=[[UIApplication sharedApplication]delegate];
    share = [[GPPShare alloc] initWithClientID:@"1028890509676.apps.googleusercontent.com"];
    share.delegate = self;
    app.share = share;
    
    [myticker invalidate];
    myticker = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showActivity) userInfo:nil repeats:YES];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];

    
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 374)];
    [scroll setScrollEnabled:YES];
    [scroll setContentSize:CGSizeMake(320, 900)];
    [scroll setBackgroundColor:[UIColor colorWithRed:212.0f / 255 green:212.0f / 255 blue:212.0f / 255 alpha:1]];
    CustomLabel *lblTitolo = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 10, 300, 90)];
    [lblTitolo setLineHeight:20];
    [lblTitolo setVerticalAlignment:MSLabelVerticalAlignmentTop];
    [lblTitolo setNumberOfLines:3];
    [lblTitolo setText:offertaSelezionata.Titolo];
    
    [lblTitolo setFont:[UIFont fontWithName:@"Bebas Neue" size:18]];
    [lblTitolo setTextColor:[UIColor colorWithRed:56.0f / 255 green:57.0f / 255 blue:59.0f / 255 alpha:1]];
    [lblTitolo setBackgroundColor:[UIColor clearColor]];
    
    [scroll addSubview:lblTitolo];
    
    NSString *html= [NSString stringWithFormat:@"<b><font color='#e14d89' size='7' face='Helvetica Neue'>€%.0f<small>.<sup>00</sup></small></font></b>", offertaSelezionata.PrezzoFinale];
    
    UIWebView *prezzoFinale = [[UIWebView alloc] initWithFrame:CGRectMake(170, 80, 140, 70)];
    [prezzoFinale loadHTMLString:html baseURL:nil];
    [prezzoFinale setBackgroundColor:[UIColor clearColor]];
    prezzoFinale.opaque = NO;
    prezzoFinale.backgroundColor = [UIColor clearColor];
    [self hideGradientBackground:prezzoFinale];
    
    [scroll addSubview:prezzoFinale];
    
    UILabelStrikethrough *lblPrezzoPartenza = [[UILabelStrikethrough alloc] initWithFrame:CGRectMake(220, 140, 70, 30)];
  

    [lblPrezzoPartenza setText:[NSString stringWithFormat:@"€%.2f", offertaSelezionata.PrezzoPartenza]];
    [lblPrezzoPartenza setBackgroundColor:[UIColor clearColor]];
    [lblPrezzoPartenza setFont:[UIFont fontWithName:@"Helvetica Neue-Regular" size:18]];
    [lblPrezzoPartenza setTextColor:[UIColor colorWithRed:91.0f / 255
                                                  green:91.0f /
                                   255 blue:91.0f / 255
                                                  alpha:1]];
    [scroll addSubview:lblPrezzoPartenza];
    
    
    UIImageView *sep1 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 170, 136, 2)];
    [sep1 setImage:[UIImage imageNamed:@"separator1.png"]];
    
    [scroll addSubview:sep1];
    
    UIImageView *sep2 = [[UIImageView alloc] initWithFrame:CGRectMake(235, 185, 1, 51)];
    [sep2 setImage:[UIImage imageNamed:@"separator2.png"]];
    
    [scroll addSubview:sep2];
    
    UILabel *lblSconto = [[UILabel alloc] initWithFrame:CGRectMake(185, 170, 80, 50)];
    [lblSconto setText:[NSString stringWithFormat:@"%.0f%%", offertaSelezionata.Sconto]];
    [lblSconto setBackgroundColor:[UIColor clearColor]];
    [lblSconto setFont:[UIFont fontWithName:@"Helvetica Neue" size:20]];
    [lblSconto setTextColor:[UIColor colorWithRed:7.0f / 255
                                            green:0
                                             blue:0
                                            alpha:1]];
    [scroll addSubview:lblSconto];

    
    UILabel *lblIntestazioneSconto = [[UILabel alloc] initWithFrame:CGRectMake(175, 190, 80, 50)];
    [lblIntestazioneSconto setText:@"Sconto"];
    [lblIntestazioneSconto setBackgroundColor:[UIColor clearColor]];
    [lblIntestazioneSconto setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    [lblIntestazioneSconto setTextColor:[UIColor colorWithRed:162.0f / 255
                                            green:162.0f / 255
                                             blue:162.0f / 255
                                            alpha:1]];

    
    [scroll addSubview:lblIntestazioneSconto];
    
    UILabel *lblAcquistati= [[UILabel alloc] initWithFrame:CGRectMake(263, 170, 80, 50)];
    [lblAcquistati setText:[NSString stringWithFormat:@"%i", offertaSelezionata.CouponAcquistati]];
    [lblAcquistati setBackgroundColor:[UIColor clearColor]];
    [lblAcquistati setFont:[UIFont fontWithName:@"Helvetica Neue" size:20]];
    [lblAcquistati setTextColor:[UIColor colorWithRed:7.0f / 255
                                            green:0
                                             blue:0
                                            alpha:1]];
    [scroll addSubview:lblAcquistati];
    
    
    UILabel *lblIntestazioneAcquistati = [[UILabel alloc] initWithFrame:CGRectMake(245, 190, 80, 50)];
    [lblIntestazioneAcquistati setText:@"Acquistati"];
    [lblIntestazioneAcquistati setBackgroundColor:[UIColor clearColor]];
    [lblIntestazioneAcquistati setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    [lblIntestazioneAcquistati setTextColor:[UIColor colorWithRed:162.0f / 255
                                                        green:162.0f / 255
                                                         blue:162.0f / 255
                                                        alpha:1]];
    
    
    [scroll addSubview:lblIntestazioneAcquistati];
    
       NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dataScadenza = [dateformatter dateFromString:offertaSelezionata.DataScadenza];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit  | NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit fromDate:dataScadenza];

    
    UILabel *lblValidita = [[UILabel alloc] initWithFrame:CGRectMake(80, 235, 250, 50)];
    [lblValidita setText:[NSString stringWithFormat:@"Valido fino alle %i:%i del %i/%i/%i", components.hour, components.minute, components.day, components.month, components.year]];
    [lblValidita setBackgroundColor:[UIColor clearColor]];
    [lblValidita setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
    [lblValidita setTextColor:[UIColor colorWithRed:108.0f / 255
                                                            green:108.0f / 255
                                                             blue:108.0f / 255
                                                            alpha:1]];
    
    
    [scroll addSubview:lblValidita];
    
    UIImageView *imgTime = [[UIImageView alloc] initWithFrame:CGRectMake(56, 253, 15, 16)];
    [imgTime setImage:[UIImage imageNamed:@"iconTime2.png"]];
    [scroll addSubview:imgTime];
    
    UIImageView *sep3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 275, 314, 1)];
    [sep3 setImage:[UIImage imageNamed:@"separator.png"]];
    
    [scroll addSubview:sep3];

    UILabel *lblInBreve = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 50, 50)];
    [lblInBreve setText:@"In breve"];
    [lblInBreve setBackgroundColor:[UIColor clearColor]];
    [lblInBreve setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
    [lblInBreve setTextColor:[UIColor colorWithRed:56.0f / 255
                                              green:57.0f / 255
                                               blue:59.0f / 255
                                              alpha:1]];
    
    [scroll addSubview:lblInBreve];
    
    
    UIWebView *lblDescrizione = [[UIWebView alloc] initWithFrame:CGRectMake(10, 320, 300, 1200)];
   
     NSString *res = [NSString stringWithFormat:@"<font color='#38393b' size='2' face='Helvetica'>%@</font>", offertaSelezionata.Descrizione];
    
    [lblDescrizione loadHTMLString:res baseURL:nil];
    [lblDescrizione setBackgroundColor:[UIColor clearColor]];
    lblDescrizione.opaque = NO;
    lblDescrizione.backgroundColor = [UIColor clearColor];
    [self hideGradientBackground:lblDescrizione];
    [lblDescrizione.scrollView setScrollEnabled:NO];
    [scroll addSubview:lblDescrizione];

    int webViewHeigth = [[lblDescrizione stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"] intValue];
 
    
    [scroll setContentSize:CGSizeMake(320,  webViewHeigth - lblDescrizione.frame.origin.y + scroll.contentSize.height)];
    
    UIImageView *imgd = [[UIImageView alloc] initWithFrame:CGRectMake(10, 90, 150, 150)];
     [scroll addSubview:imgd];
    
    
    if ([offertaSelezionata.immagini count]>=1)
    {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            
            NSString *url = [NSString stringWithFormat:@"http://www.specialdeal.it/crop/170x170/%@",[offertaSelezionata.immagini objectAtIndex:0]];
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
            
            UIImage *img = [UIImage imageWithData:data];
            
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                // offerta.Immagine = img;
                imgd.image = img;
                [imgd setNeedsLayout];
            });
        });
    }
    
    [self.view addSubview:scroll];
    
    
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
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
   // NSString *name = self.loggedInUser.first_name;
    NSString *message = @"Ok";
    
    
    
    NSMutableDictionary *postParams =  [[NSMutableDictionary alloc] initWithObjectsAndKeys:offertaSelezionata.Url, @"link", [offertaSelezionata.immagini objectAtIndex:0], @"picture",
                                        offertaSelezionata.Titolo,@"name",nil];
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:postParams
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
                              
                              [self showAlert:message result:result error:error];
                          }];

    
    // if it is available to us, we will post using the native dialog
   /* BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                    initialText:nil
                                                                          image:nil
                                                                            url:nil
                                                                        handler:nil];
    
    if (TRUE) {
          
   
        NSMutableDictionary *postParams =  [[NSMutableDictionary alloc] initWithObjectsAndKeys:offertaSelezionata.Url, @"link", offertaSelezionata.ImmaginePrimoPiano, @"picture", 
                                            offertaSelezionata.Titolo,@"name",nil];
        
        [FBRequestConnection startWithGraphPath:@"me/feed"
                                     parameters:postParams
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
                                  
                                  [self showAlert:message result:result error:error];
                              }];

    }
    else
    {
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    
                    NSLog(@"Cancelled");
                    
                } else
                    
                {
                    NSLog(@"Done");
                }
                
                [controller dismissViewControllerAnimated:YES completion:Nil];
            };
                        
             [controller setTitle:@"xxxx"];
           // [controller addURL:[NSURL URLWithString:@"http://www.mobile.safilsunny.com"]];
           // [controller addImage:[UIImage imageNamed:@"fb.png"]];
            
            controller.completionHandler =myBlock;

            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
        
    }*/
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

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"pagamento"]) {
        
        
        // Get reference to the destination view controller
        PagamentoViewController *vc = [segue destinationViewController];
        
        // get the selected index
        vc.offertaSelezionata = offertaSelezionata;
    }    
}
@end
