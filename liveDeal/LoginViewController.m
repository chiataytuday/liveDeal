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
@synthesize navBar, txtEmail, txtPwd, imgViewLogFB, loggedInUser, delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sfondoRegistrati.png"]]];
    
  
}


-(IBAction)logon:(id)sender{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *url = [NSString stringWithFormat:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/login?username=%@&password=%@&tokenAPN=%@", txtEmail.text, txtPwd.text, [defaults objectForKey:@"tokenAPN"]];
    
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
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[member objectForKey:@"firstname"] forKey:@"nomeUtenteLog"];
        [[NSUserDefaults standardUserDefaults] setObject:[member objectForKey:@"lastname"] forKey:@"cognomeUtenteLog"];
        [[NSUserDefaults standardUserDefaults] setObject:[member objectForKey:@"id"] forKey:@"idUtenteLog"];

        [[NSUserDefaults standardUserDefaults] setObject:txtEmail.text forKey:@"emailLogged"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        if (self.delegate != nil)
            [self.delegate didSelect:u  andIdentifier:@"user"];
       
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"email non trovata o password errata" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];

    }
    
}



-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
   
    
    switch (state) {
        case FBSessionStateOpen:
           
               
            
           
            [defaults setBool:YES forKey:@"isLoggedIn"];
            [defaults synchronize];
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


- (IBAction)performLogin:(id)sender
{
       [self openSession];
}

- (IBAction)goBack:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end
