//
//  PagamentoViewController.m
//  liveDeal
//
//  Created by claudio barbera on 29/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "PagamentoViewController.h"
#define MAX_NUMBER_OF_COUPON 30

@interface PagamentoViewController ()

@end

@implementation PagamentoViewController
@synthesize img, lblTitolo, lblDescrizione, offertaSelezionata, lblValidita, lblQta, lblTot, btnPaga, imgCell, lblCC, imgPaypal;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sfondoDetail.png"]]];
   
    
    [lblCC setHidden:YES];
    
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSceltaPagamento)];
    
    [imgCell addGestureRecognizer:tapRecognize];
    
    
    [lblTitolo setLineHeight:20];
    [lblTitolo setVerticalAlignment:MSLabelVerticalAlignmentTop];
    [lblTitolo setText:offertaSelezionata.Titolo];
    
    [lblTitolo setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [lblTitolo setTextColor:[UIColor colorWithRed:56.0f / 255 green:57.0f / 255 blue:59.0f / 255 alpha:1]];
    [lblTitolo setBackgroundColor:[UIColor clearColor]];
    
    [lblDescrizione setLineHeight:10];
    [lblDescrizione setVerticalAlignment:MSLabelVerticalAlignmentTop];
    [lblDescrizione setText:offertaSelezionata.Descrizione];
    
    [lblValidita setText:offertaSelezionata.Validita];
    
    
    [lblQta setFont:[UIFont fontWithName:@"Bebas Neue" size:26]];
    [lblQta setTextColor:[UIColor colorWithRed:78.0f / 255 green:47.0f / 255 blue:13.0f / 255 alpha:1]];
    [lblQta setBackgroundColor:[UIColor clearColor]];
    
    [lblTot setFont:[UIFont fontWithName:@"Bebas Neue" size:26]];
    [lblTot setTextColor:[UIColor colorWithRed:225.0f / 255 green:77.0f / 255 blue:137.0f / 255 alpha:1]];
    [lblTot setBackgroundColor:[UIColor clearColor]];


    [self aggiornaTotaleWithQuantita:1];
    
    if (offertaSelezionata.Immagine!=nil)
        img.image = offertaSelezionata.Immagine;
    else
    {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[offertaSelezionata.immagini objectAtIndex:0]]];
            
            imgDeal = [UIImage imageWithData:data];
                        
            dispatch_sync(dispatch_get_main_queue(), ^{
                offertaSelezionata.Immagine = imgDeal;
                img.image = imgDeal;
                [img setNeedsLayout];
            });
        });
    }

    

}

-(void)didSelect:(id)object andIdentifier:(NSString *)identifier
{

    if ([object isEqualToString:@"CC"])
    {
        [lblCC setHidden:NO];
        [imgPaypal setHidden:YES];
    }
    else
    {
        [lblCC setHidden:YES];
        [imgPaypal setHidden:NO];
    }
    
}

-(void)openSceltaPagamento
{
    [self performSegueWithIdentifier:@"sceltaPagamento" sender:self];
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

    ScegliPagamentoViewController *vc = [segue destinationViewController];
    vc.delegate = self;
}

- (IBAction)decrementa:(id)sender{

    int count = [lblQta.text integerValue];
    
    if (count>1){
        lblQta.text = [NSString stringWithFormat:@"%i", --count];
        [self aggiornaTotaleWithQuantita:count];
    }
}

- (IBAction)test:(id)sender {
    
    LoginViewController *l = [[LoginViewController alloc] init];
    [self.navigationController presentViewController:l animated:YES completion:nil];
}

-(void)aggiornaTotaleWithQuantita:(int)quantita
{
    double tot = offertaSelezionata.PrezzoFinale * quantita;
    [lblTot setText:[NSString stringWithFormat:@"%.2f €",tot]];
    [btnPaga setTitle:[NSString stringWithFormat:@"Acquista  %.2f €", tot] forState:UIControlStateNormal];
}
@end
