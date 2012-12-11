//
//  ScegliPagamentoViewController.m
//  liveDeal
//
//  Created by claudio barbera on 30/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "ScegliPagamentoViewController.h"

@interface ScegliPagamentoViewController ()

@end

@implementation ScegliPagamentoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0)
        [self.delegate didSelect:@"CC" andIdentifier:@"tipoPagamento"];
    else
        [self.delegate didSelect:@"PP" andIdentifier:@"tipoPagamento"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
