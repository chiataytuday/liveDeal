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
     setFinishedSelectedImage:[UIImage imageNamed:@"iconOfferteHover.png"]
     withFinishedUnselectedImage:[UIImage imageNamed:@"iconOfferteHover.png"]];
    
    [[self.tabBar.items objectAtIndex:1]
     setFinishedSelectedImage:[UIImage imageNamed:@"iconAccountNormal.png"]
     withFinishedUnselectedImage:[UIImage imageNamed:@"iconAccountNormal.png"]];
    
    [[self.tabBar.items objectAtIndex:2]
     setFinishedSelectedImage:[UIImage imageNamed:@"iconPreferitiHover.png"]
     withFinishedUnselectedImage:[UIImage imageNamed:@"iconPreferitiNormal.png"]];
    
    [[self.tabBar.items objectAtIndex:3]
     setFinishedSelectedImage:[UIImage imageNamed:@"iconAltroNormal.png"]
     withFinishedUnselectedImage:[UIImage imageNamed:@"iconAltroNormal.png"]];


}


@end
