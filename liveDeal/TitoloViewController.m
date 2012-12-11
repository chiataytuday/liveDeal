//
//  TitoloViewController.m
//  liveDeal
//
//  Created by claudio barbera on 21/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "TitoloViewController.h"

@interface TitoloViewController ()

@end

@implementation TitoloViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titolo;
    
    if (indexPath.row==0)
        titolo = @"M";
    else
        titolo=@"F";
   
    [self.delegate didSelect:titolo andIdentifier:@"titolo"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"titoloCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row==0)
        cell.textLabel.text = @"M";
    else
        cell.textLabel.text=@"F";
    
    return cell;
}


@end
