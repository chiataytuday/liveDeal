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
@synthesize loginController, user;

-(void)viewWillAppear:(BOOL)animated
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
    
    loginController = [storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
    loginController.delegate = self;
    
    NSString *tokenAccess = [defaults objectForKey:@"token_access"];
    
    if (![Utility isTokenValidWithToken:tokenAccess])
    {
        [self.navigationController pushViewController:loginController animated:YES];
        
    }
    /*
    if (tokenAccess==nil)
        [self.navigationController pushViewController:loginController animated:YES];
    else{
        NSString *url=@"";
        
        if ([defaults objectForKey:@"tokenAPN"]!= nil)
            url =[NSString stringWithFormat:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/login?token_access=%@&tokenAPN=%@",
                  tokenAccess, [defaults objectForKey:@"tokenAPN"]];
        else
            url= [NSString stringWithFormat:@"http://www.specialdeal.it/api/jsonrpc2/v1/deals/login?token_access=%@",
                  tokenAccess];
        
        [self Ricerca:url];
    }*/
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
   
    UIImageView *imgSfondo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sfondoRegistrati.png"]];
    [imgSfondo setContentMode:UIViewContentModeScaleAspectFill];
    
    [imgSfondo setFrame:self.view.frame];
    
    self.tableView.backgroundView = imgSfondo;
    
    
    
      

}



-(void)didSelect:(id)object andIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:@"user"])
    {
        user = (User *)object;
        [self.tableView reloadData];
    }
}

-(void)login
{

   // [self presentModalViewController:loginController animated:YES];

}
-(void)logout{

    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
     [FBSession.activeSession closeAndClearTokenInformation];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:NULL forKey:@"token_access"];
    [defaults synchronize];
    
    [self.tableView reloadData];
   [self.navigationController pushViewController:loginController animated:NO];
}


-(void)didAuthenticateWithFB:(BOOL)isFb
{
    
    if (isFb){
    [[[FBRequest alloc] initWithSession:FBSession.activeSession graphPath:@"me"]  startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *userFB,
       NSError *error) {
         if (!error) {
             //ho ottenuto l'id FB. faccio una richiesta per ottenere i dati attraverso l'id FB
             NSString *url = [NSString stringWithFormat:@"http://www.psicologapalermo.com/userInfo.txt?FacebookUserID=%@", userFB.id];
             [self Ricerca:url];
         }
     }];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *emailLogged = [defaults objectForKey:@"email_logged"];
        
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
    if ([[segue identifier] isEqualToString:@"datiUtente"]) {
    
        UserDetailViewController *vc = [segue destinationViewController];
        
        vc.user = user;
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
                     JSONObjectWithData:tempArray
                     options:kNilOptions error:nil];
    
    
    NSArray *result = [json valueForKeyPath:@"result"];
    NSDictionary *member = [result valueForKeyPath:@"Member"];
    
    if (member!=nil)
    {
        user = [[User alloc] init];
        [user setNome:[member objectForKey:@"firstname"]];
        [user setCognome:[member objectForKey:@"lastname"]];
        [user setEmail:[member objectForKey:@"email"]];
        if ([[member objectForKey:@"gender"] isEqualToString:@"M"])
            [user setSesso:@"Maschio"];
        else if ([[member objectForKey:@"gender"] isEqualToString:@"F"])
            [user setSesso:@"Femmina"];

        
        [self.tableView reloadData];
           
    }
    else
    {
        [hud hide:YES];
        [self.navigationController pushViewController:loginController animated:NO];
        
    }
    
    [hud hide:YES];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [hud hide:YES];
   
  //  [self.navigationController pushViewController:loginController animated:NO];//
    
}

#pragma mark - Table View Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    UILabel *lblInt = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 320, 25)];
    [lblInt setFont:[UIFont systemFontOfSize:12]];
    
    if (user!=nil)
        lblInt.text =  [NSString stringWithFormat:@"Benvenuto %@ %@", user.nome, user.cognome];
    
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

    
        [btnDisconnetti addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
   
    [base addSubview:btnDisconnetti];


    [footer addSubview:base];
    
    return  footer;
}
@end
