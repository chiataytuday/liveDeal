//
//  LoginViewController.m
//  liveDeal
//
//  Created by claudio barbera on 17/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize txtEmail, txtPwd, loggedInUser, delegate, loginDelegate, showBackButton;

-(void)viewWillAppear:(BOOL)animated
{
   
    txtPwd.text=@"";
    txtEmail.text=@"";
    
    if(!showBackButton)
    {
        self.navigationItem.hidesBackButton = YES;

    }
    
}

-(void)chiudi
{
    [self dismissModalViewControllerAnimated:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
      
        
	// Do any additional setup after loading the view.
   // self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sfondoRegistrati.png"]]];
}

- (IBAction)performLogin:(id)sender
{
    [self openSession];
}

-(IBAction)logon:(id)sender{
    
    tipoRichiesta=LOGIN;
    
    [txtPwd resignFirstResponder];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *url = @"";
    
    if ([defaults objectForKey:@"tokenAPN"]!=nil)
        url = [NSString stringWithFormat:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/login?username=%@&password=%@&tokenAPN=%@", txtEmail.text, txtPwd.text, [defaults objectForKey:@"tokenAPN"]];
    else
        url = [NSString stringWithFormat:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/login?username=%@&password=%@", txtEmail.text, txtPwd.text];

    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]  cachePolicy:NSURLRequestUseProtocolCachePolicy
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

#pragma mark - uitextfielddelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    if (tipoRichiesta==LOGIN) {
        
        NSArray* json = [NSJSONSerialization
                         JSONObjectWithData:tempArray
                         options:kNilOptions error:nil];
        
        
        NSArray *result = [json valueForKeyPath:@"result"];
        NSDictionary *member = [result valueForKeyPath:@"Member"];
        
        if (member!=nil)
        {
            User *u = [[User alloc] init];
            [u setNome:[member objectForKey:@"firstname"]];
            [u setCognome:[member objectForKey:@"lastname"]];
            [u setEmail:[member objectForKey:@"email"]];
            
            
            if ([[member objectForKey:@"gender"] isEqualToString:@"M"])
                [u setSesso:@"Maschio"];
            else if ([[member objectForKey:@"gender"] isEqualToString:@"F"])
                [u setSesso:@"Femmina"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[member objectForKey:@"token_access"] forKey:@"token_access"];
             [[NSUserDefaults standardUserDefaults] setObject:[member objectForKey:@"email"] forKey:@"email_logged"];
            [[NSUserDefaults standardUserDefaults] setObject:[member objectForKey:@"id"] forKey:@"userId"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (self.delegate != nil)
                [self.delegate didSelect:u  andIdentifier:@"user"];
            
            [hud hide:YES];
            
            
            
            [self.navigationController popViewControllerAnimated:NO];
            
            [self.loginDelegate didAutenticate];
            
            
            
        }
        else
        {
            
            [hud hide:YES];
            
            NSDictionary *error = [json valueForKeyPath:@"error"];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat: @"Errore %@", [error objectForKey:@"code"]] message:[error objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
    }
    else
    {
         [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Ok" message:@"Ti è stata inviata la password all'indirizzo specificato" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
}



-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert show];
}

#pragma mark - Facebook delegate
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    
    switch (state) {
        case FBSessionStateOpen:
           
            [self.navigationController popViewControllerAnimated:YES];
            
            /*if ([self respondsToSelector:@selector(dismissViewControllerAnimated:animated:completion:)]){
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            [self.delegate didAuthenticateWithFB:YES]*/
             
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            
            if ([self respondsToSelector:@selector(dismissViewControllerAnimated:animated:completion:)]){
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
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

-(IBAction)richiediPassword:(id)sender{
    
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Richiesta password" message:@"Inserisci l'email con la quale ti sei registrato" delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:@"Ok", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    // Change keyboard type
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
    [dialog show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1){
        
        tipoRichiesta = FORGOT_PASSWORD;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/forgotPassword"]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:60.0];
        
        NSString *emailEncode = [[[alertView textFieldAtIndex:0]text] urlEncode];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[[NSString stringWithFormat:@"email=%@",
                              emailEncode] dataUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (connection)
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
}


@end
