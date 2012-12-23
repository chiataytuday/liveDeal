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
/*
    NSString *url = [NSString stringWithFormat:@"http://www.psicologapalermo.com/login.txt?email=%@&pwd=%@", txtEmail.text, txtPwd.text];
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
*/
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:YES forKey:@"isLoggedIn"];
    [defaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    
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
                     JSONObjectWithData:tempArray //1
                     options:kNilOptions error:nil];
    
    
    BOOL aut = [[json valueForKeyPath:@"authorized"] boolValue];
    
    if (aut)
    {
        [[NSUserDefaults standardUserDefaults] setObject:txtEmail.text forKey:@"emailLogged"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.delegate didAuthenticateWithFB:NO];
       
        if ([self respondsToSelector:@selector(dismissViewControllerAnimated:animated:completion:)]){
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    else
    {
        NSLog(@"Non autorizzato");
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
