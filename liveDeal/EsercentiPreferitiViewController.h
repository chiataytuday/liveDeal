//
//  EsercentiPreferitiViewController.h
//  liveDeal
//
//  Created by claudio barbera on 25/12/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "EsercenteST.h"
#import "CustomLabel.h"
#import "EsercenteViewController.h"

@interface EsercentiPreferitiViewController :  UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSArray *esercentiPreferiti;
@property (nonatomic, retain) NSFetchedResultsController  *fetchedResultsController;

-(NSFetchedResultsController *)fetchedResultsController;

@end
