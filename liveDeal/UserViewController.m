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
@synthesize lbl;



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
   
    UIImageView *imgSfondo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sfondoRegistrati.png"]];
    [imgSfondo setContentMode:UIViewContentModeScaleAspectFill];
    
    [imgSfondo setFrame:self.view.frame];
    
    self.tableView.backgroundView = imgSfondo;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    bool isLoggedIn = [defaults boolForKey:@"isLoggedIn"];
    
    if (!isLoggedIn){
        UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
        
        UIViewController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
        
        [self.navigationController pushViewController:loginController animated:NO];//
    }
    
 //  presentModalViewController:loginController animated:NO];

    
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

    /*
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
     [FBSession.activeSession closeAndClearTokenInformation];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"emailLogged"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    //nascondo il pulsante di logout
    [btnLogout setHidden:YES];
    
    //mostro il pulsante di login
    [btnLogin setHidden:NO];
    
    [mainView setHidden:YES];
    [btnRegistrati setHidden:NO];*/
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:@"isLoggedIn"];
    [defaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    
    UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
    
    UIViewController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
    
    [self.navigationController pushViewController:loginController animated:NO];//

    

}


-(void)didAuthenticateWithFB:(BOOL)isFb
{
    
     
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
           
    
   // [mainView setHidden:NO];
    [hud hide:YES];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errore" message:@"Impossibile connettersi" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert show];}

#pragma mark - Table View Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    UILabel *lblInt = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 320, 25)];
    [lblInt setText:@"Sei collegato come barbera.claudio@gmail.com"];
    [lblInt setFont:[UIFont systemFontOfSize:12]];
    [lblInt setBackgroundColor:[UIColor clearColor]];
    [header addSubview:lblInt];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
     
    UIImageView *base = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baseLoginFb.png"]];
    [base setFrame:CGRectMake(20, 20, 280, 64)];
    [base setUserInteractionEnabled:YES];
    
    UIButton *btnDisconnetti = [[UIButton alloc] initWithFrame:CGRectMake(20, 17, 240, 30)];
 //   [btnDisconnetti setTitle:@"Disconnetti" forState:UIControlStateNormal];
    [btnDisconnetti setImage:[UIImage imageNamed:@"disconnetti.png"] forState:UIControlStateNormal];

    [btnDisconnetti addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    
    [base addSubview:btnDisconnetti];


    [footer addSubview:base];
    
    return  footer;
}
@end
