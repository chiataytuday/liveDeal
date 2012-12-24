//
//  EsercenteVetrinaViewController.m
//  liveDeal
//
//  Created by claudio barbera on 24/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "EsercenteVetrinaViewController.h"

@interface EsercenteVetrinaViewController ()

@end

@implementation EsercenteVetrinaViewController
@synthesize esercenteSelezionato, lblRagSoc;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    lblRagSoc.text = esercenteSelezionato.RagioneSociale;
}


@end
