//
//  RegistrazioneViewController.m
//  liveDeal
//
//  Created by claudio barbera on 21/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "RegistrazioneViewController.h"

@interface RegistrazioneViewController ()

@end

@implementation RegistrazioneViewController
@synthesize txtCognome, txtNome, txtEmail, txtCitta, txtPassword, txtConfermaPassword, txtSesso;


- (void)viewDidLoad
{
    [super viewDidLoad];

           
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 374)];
    [scroll setContentSize:CGSizeMake(320, 493)];
    [scroll setBounces:YES];
    [scroll setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sfondoRegistrati.png"]]];
    
    UIButton *btnRegFB = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRegFB setFrame:CGRectMake(32, 20, 251, 31)];
    [btnRegFB setImage:[UIImage imageNamed:@"loginFb.png"] forState:UIControlStateNormal];
    [btnRegFB addTarget:self action:@selector(loginFb) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:btnRegFB];   
    
    UIImageView *sfondoReg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 75, 271, 337)];
    [sfondoReg setImage:[UIImage imageNamed:@"sfondoRegistrazione.png"]];
    [scroll addSubview:sfondoReg];
    
    UIImageView *baseReg = [[UIImageView alloc] initWithFrame:CGRectMake(33, 85, 256, 287)];
    [baseReg setImage:[UIImage imageNamed:@"baseRegistrazione.png"]];
    [scroll addSubview:baseReg];
    
    
    txtEmail = [[UITextField alloc] initWithFrame:CGRectMake(115, 93, 165, 30)];
    [txtEmail setDelegate:self];
    [txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    [scroll addSubview:txtEmail];
    
    txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(135, 133, 145, 30)];
    [txtPassword setDelegate:self];    
    [txtPassword setKeyboardType:UIKeyboardTypeDefault];
    txtPassword.secureTextEntry=YES;
    [scroll addSubview:txtPassword];
    
    txtConfermaPassword = [[UITextField alloc] initWithFrame:CGRectMake(165, 173, 115, 30)];
    [txtConfermaPassword setDelegate:self];
    [txtConfermaPassword setKeyboardType:UIKeyboardTypeDefault];
    txtConfermaPassword.secureTextEntry=YES;
    [scroll addSubview:txtConfermaPassword];    
    
    txtNome = [[UITextField alloc] initWithFrame:CGRectMake(125, 220, 155, 30)];
    [txtNome setDelegate:self];
    [txtNome setKeyboardType:UIKeyboardTypeDefault];
    [scroll addSubview:txtNome];
    
    txtCognome= [[UITextField alloc] initWithFrame:CGRectMake(130, 257, 150, 30)];
    [txtCognome setDelegate:self];
    [txtCognome setKeyboardType:UIKeyboardTypeDefault];
    [scroll addSubview:txtCognome];

    txtSesso= [[UITextField alloc] initWithFrame:CGRectMake(125, 300, 155, 30)];
    [txtSesso setDelegate:self];
    [txtSesso setKeyboardType:UIKeyboardTypeDefault];
    [txtSesso setTag:2];
    [scroll addSubview:txtSesso];
    
    txtCitta= [[UITextField alloc] initWithFrame:CGRectMake(155, 340, 125, 30)];
    [txtCitta setDelegate:self];
    [txtCitta setTag:3];
    [scroll addSubview:txtCitta];

    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(270, 305, 7, 13)];
    [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
    [scroll addSubview:arrow];


    UIImageView *arrow2= [[UIImageView alloc] initWithFrame:CGRectMake(270, 345, 7, 13)];
    [arrow2 setImage:[UIImage imageNamed:@"arrow.png"]];
    [scroll addSubview:arrow2];

    UIButton *btnReg = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnReg setFrame:CGRectMake(35, 375, 251, 31)];
    [btnReg setImage:[UIImage imageNamed:@"registrati.png"] forState:UIControlStateNormal];
    [btnReg addTarget:self action:@selector(registrati) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:btnReg];
    
    [self.view addSubview:scroll];
    
    }


-(void)didSelect:(id)object andIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:@"titolo"]){
        NSString *tit = (NSString *)object;
        [txtSesso setText:tit];
    }
    else if ([identifier isEqualToString:@"citta"]){
        Citta *city = (Citta *)object;
        [txtCitta setText:city.Descrizione];

    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==2)
    {
        [self performSegueWithIdentifier:@"titolo" sender:self];
         return NO;
    }
    else if (textField.tag==3)
    {
        [self performSegueWithIdentifier:@"citta" sender:self];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;
}


-(void)loginFb
{
     [self openSession];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            [self recuperaDatiFB];
            
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

-(void)recuperaDatiFB
{
     
   
   [[[FBRequest alloc] initWithSession:FBSession.activeSession graphPath:@"me"]  startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 [txtNome setText:user.first_name];
                 [txtCognome setText:user.last_name];
                 [txtEmail setText:[user objectForKey:@"email"]];
                 [txtCitta setText:[[user objectForKey:@"location"] name]];
                 NSString *gender = [user objectForKey:@"gender"];
                 
                 if ([gender isEqualToString:@"male"])
                     [txtSesso setText:@"M"];
                 else if ([gender isEqualToString:@"female"])
                      [txtSesso setText:@"F"];
                 
             }
         }];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"titolo"])
    {
        TitoloViewController *t = [segue destinationViewController ];
        t.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"citta"]){
    
        CitiesViewController *cvc = [segue destinationViewController];
        cvc.delegate = self;
    }
}

- (void)openSession
{
    NSArray *permissions = [[NSArray alloc] initWithObjects: @"email", nil];
  
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}



@end
