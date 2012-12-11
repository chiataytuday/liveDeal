//
//  TabBarViewController.m
//  liveDeal
//
//  Created by claudio barbera on 01/01/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage imageNamed:@"backgroundTabBar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"toolbarSelected.png"]];

    
    [[self.tabBar.items objectAtIndex:0]
     setFinishedSelectedImage:[UIImage imageNamed:@"home.png"]
     withFinishedUnselectedImage:[UIImage imageNamed:@"home.png"]];
    
    [[self.tabBar.items objectAtIndex:1]
     setFinishedSelectedImage:[UIImage imageNamed:@"calendar.png"]
     withFinishedUnselectedImage:[UIImage imageNamed:@"calendar.png"]];

}


@end
