//
//  ViewController.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 01/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "MainViewController.h"
#import "DataManager.h"

@interface MainViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[DataManager sharedInstance] loadData];
  
  self.view.backgroundColor = UIColor.grayColor;
  self.activityIndicator = [self createActivityIndicator];
  [self.view addSubview:_activityIndicator];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(dataLoaded)
                                               name:kDataManagerLoadDataDidComplete
                                             object:nil];
}

- (UIActivityIndicatorView *)createActivityIndicator
{
  UIActivityIndicatorView *loadingDataActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  loadingDataActivityIndicatorView.frame = self.view.bounds;
  [loadingDataActivityIndicatorView startAnimating];
  return loadingDataActivityIndicatorView;
}

- (void)dataLoaded
{
  UIColor *lightBlueColor = [UIColor colorWithRed:97.0/255.0
                                            green:215.0/255.0
                                             blue:255.0/255.0
                                            alpha:1];
  
  UIColor *customBlueColor = [UIColor colorWithRed:72.0/255.0
                                             green:150.0/255.0
                                              blue:236.0/255.0
                                             alpha:1];
  
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = self.view.bounds;
  gradient.startPoint = CGPointMake(0.0, 0.0);
  gradient.endPoint = CGPointMake(1.0, 1.0);
  gradient.colors = @[(id)customBlueColor.CGColor,
                      (id)lightBlueColor.CGColor];
  [self.view.layer addSublayer:gradient];
  
  [self.activityIndicator removeFromSuperview];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kDataManagerLoadDataDidComplete
                                                object:nil];
}

@end
