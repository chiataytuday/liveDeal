//
//  UserViewController.m
//  liveDeal
//
//  Created by claudio barbera on 01/01/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "UserViewController.h"


@interface UserViewController ()

@end

@implementation UserViewController
@synthesize lbl,btnLogin, btnLogout, mainView, btnRegistrati;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
    
    UIViewController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
    
    [self presentModalViewController:loginController animated:YES];

    
    /*[mainView setHidden:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *emailLogged = [defaults objectForKey:@"emailLogged"];
    
    if (emailLogged!=NULL)
    {
        //login effettuato con user e pwd
        [self didAuthenticateWithFB:NO];
    }
    else if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
       
        [self didAuthenticateWithFB:YES];
        
    } else {
        // No, display the login page.
        [btnLogout setHidden:YES];
        [btnLogin setHidden:NO];
        [btnRegistrati setHidden:NO];

    }*/
}


-(IBAction)logout:(id)sender{

    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
     [FBSession.activeSession closeAndClearTokenInformation];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"emailLogged"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    //nascondo il pulsante di logout
    [btnLogout setHidden:YES];
    
    //mostro il pulsante di login
    [btnLogin setHidden:NO];
    
    [mainView setHidden:YES];
    [btnRegistrati setHidden:NO];
}

-(IBAction)goToLogin:(id)sender{

    [self performSegueWithIdentifier:@"login" sender:self];
}

-(void)didAuthenticateWithFB:(BOOL)isFb
{
    
    [btnLogout setHidden:NO];
    [btnLogin setHidden:YES];
    [btnRegistrati setHidden:YES];
     
    if (isFb){
    [[[FBRequest alloc] initWithSession:FBSession.activeSession graphPath:@"me"]  startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             //ho ottenuto l'id FB. faccio una richiesta per ottenere i dati attraverso l'id FB
             NSString *url = [NSString stringWithFormat:@"http://www.psicologapalermo.com/userInfo.txt?FacebookUserID=%@", user.id];
             [self Ricerca:url];
         }
     }];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *emailLogged = [defaults objectForKey:@"emailLogged"];
        
        NSString *url = [NSString stringWithFormat:@"http://www.psicologapalermo.com/userInfo.txt?email=%@", emailLogged];
        [self Ricerca:url];
    }

}


-(void)Ricerca:(NSString *)url
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    
    
    NSURLConnection *myConn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (myConn)
    {
        tempArray = [[NSMutableData alloc] init];
       
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"Caricamento dati...";
       
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"login"]) {
    
        LoginViewController *l = [segue destinationViewController];
        l.delegate = self;
        
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
    
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:tempArray //1
                     options:kNilOptions error:nil];
    
    
    NSDictionary *user = [json valueForKeyPath:@"user"];
    
    [lbl setText:[user valueForKey:@"email"]];
           
    
    [mainView setHidden:NO];
    [hud hide:YES];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert show];}


@end
