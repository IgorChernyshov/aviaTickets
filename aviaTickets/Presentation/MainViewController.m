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
  
  // Indicate data loading process on UI
  self.view.backgroundColor = [UIColor colorWithRed:160.0/255.0
                                              green:215.0/255.0
                                               blue:255.0/255.0
                                              alpha:1];
  self.activityIndicator = [self createActivityIndicator];
  [self.view addSubview:_activityIndicator];
  
  // Create a notification subscription to know when data has been loaded
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
  // Indicate that app is ready
  [self.activityIndicator removeFromSuperview];
  self.navigationItem.title = @"Tickets search";
  // Create a gradient background
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
  
  // Create control components
  // Segmented Control "One way - Round trip tickets"
  CGFloat segmentedControlHeight = 30.0;
  CGFloat segmentedControlWidth = 200.0;
  CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height +
                          (self.navigationController.navigationBar.frame.size.height));
  CGRect segmentedControlFrame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - segmentedControlWidth / 2,
                                            topbarHeight + segmentedControlHeight / 2,
                                            segmentedControlWidth,
                                            segmentedControlHeight);
  UISegmentedControl *ticketsTypeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Round trip", @"One way"]];
  ticketsTypeSegmentedControl.frame = segmentedControlFrame;
  ticketsTypeSegmentedControl.tintColor = [UIColor whiteColor];
  ticketsTypeSegmentedControl.selectedSegmentIndex = 0;
  [self.view addSubview:ticketsTypeSegmentedControl];
  
  // Create a stack view for components
//  UIStackView *stackView = [UIStackView new];
//
//  stackView.axis = UILayoutConstraintAxisVertical;
//  stackView.distribution = UIStackViewDistributionEqualSpacing;
//  stackView.alignment = UIStackViewAlignmentCenter;
//  stackView.spacing = 16;
//
//  [stackView addArrangedSubview:view1];
//  [stackView addArrangedSubview:view2];
//  [stackView addArrangedSubview:view3];
//
//  stackView.translatesAutoresizingMaskIntoConstraints = false;
//  [self.view addSubview:stackView];
  
  //Layout for Stack View
//  [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
//  [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kDataManagerLoadDataDidComplete
                                                object:nil];
}

@end
