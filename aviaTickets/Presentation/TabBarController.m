//
//  TabBarController.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 15/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "PriceMapViewController.h"
#import "SearchResultsViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)init
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    self.viewControllers = [self createViewControllers];
    self.tabBar.tintColor = [UIColor blackColor];
  }
  return self;
}

- (NSArray<UIViewController *> *)createViewControllers
{
  NSMutableArray<UIViewController *> *controllers = [NSMutableArray new];
  
  MainViewController *mainViewController = [MainViewController new];
  mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search Tickets" image:[UIImage imageNamed:@"searchIcon"] tag:0];
  UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
  [controllers addObject:mainNavigationController];
  
  PriceMapViewController *priceMapViewController = [PriceMapViewController new];
  priceMapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Price Map" image:[UIImage imageNamed:@"mapIcon"] tag:1];
  UINavigationController *priceMapNavigationViewController = [[UINavigationController alloc] initWithRootViewController:priceMapViewController];
  [controllers addObject:priceMapNavigationViewController];
  
  SearchResultsViewController *favouritesViewController = [SearchResultsViewController new];
  favouritesViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favourite Tickets" image:[UIImage imageNamed:@"favouritesIcon"] tag:2];
  [controllers addObject:favouritesViewController];
  
  return controllers;
}

@end
