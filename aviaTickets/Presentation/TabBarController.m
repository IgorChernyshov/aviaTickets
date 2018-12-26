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
#import "NSString+Localize.h"

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
  mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"searchTab".localize image:[UIImage imageNamed:@"searchIcon"] tag:0];
  UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
  [controllers addObject:mainNavigationController];
  
  PriceMapViewController *priceMapViewController = [PriceMapViewController new];
  priceMapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"mapTab".localize image:[UIImage imageNamed:@"mapIcon"] tag:1];
  UINavigationController *priceMapNavigationViewController = [[UINavigationController alloc] initWithRootViewController:priceMapViewController];
  [controllers addObject:priceMapNavigationViewController];
  
  SearchResultsViewController *favoritesViewController = [[SearchResultsViewController alloc] initFavoriteTicketsController];
  favoritesViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"favoritesTab".localize image:[UIImage imageNamed:@"favoritesIcon"] tag:2];
  UINavigationController *favoritesNavigationViewController = [[UINavigationController alloc] initWithRootViewController:favoritesViewController];
  [controllers addObject:favoritesNavigationViewController];
  
  return controllers;
}

@end
