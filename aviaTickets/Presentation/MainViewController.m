//
//  ViewController.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 01/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

// Import view controllers
#import "MainViewController.h"
#import "SearchResultsViewController.h"
// Import helpers
#import "DataManager.h"
// Import custom view elements
#import "MainViewButton.h"

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
  CGFloat halfScreenWidth = [UIScreen mainScreen].bounds.size.width / 2;
  CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height +
                          (self.navigationController.navigationBar.frame.size.height));
  CGRect segmentedControlFrame = CGRectMake(halfScreenWidth - segmentedControlWidth / 2,
                                            topbarHeight + segmentedControlHeight / 2,
                                            segmentedControlWidth,
                                            segmentedControlHeight);
  UISegmentedControl *ticketsTypeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Round trip", @"One way"]];
  ticketsTypeSegmentedControl.frame = segmentedControlFrame;
  ticketsTypeSegmentedControl.tintColor = [UIColor whiteColor];
  ticketsTypeSegmentedControl.selectedSegmentIndex = 0;
  [self.view addSubview:ticketsTypeSegmentedControl];
  
  // Create buttons
  UIButton *departureAirportButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  CGRect departureAirportButtonFrame = departureAirportButton.frame;
  departureAirportButtonFrame.origin = CGPointMake(halfScreenWidth - departureAirportButton.frame.size.width / 2,
                                    segmentedControlFrame.origin.y + segmentedControlFrame.size.height + departureAirportButton.frame.size.height / 2 + 16);
  departureAirportButton.frame = departureAirportButtonFrame;
  [departureAirportButton setTitle:@"Departure airport" forState:UIControlStateNormal];
  
  UIButton *destinationAirportButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  CGRect destinationAirportButtonFrame = destinationAirportButton.frame;
  destinationAirportButtonFrame.origin = CGPointMake(halfScreenWidth - destinationAirportButton.frame.size.width / 2,
                                                   departureAirportButtonFrame.origin.y + departureAirportButtonFrame.size.height + 8);
  destinationAirportButton.frame = destinationAirportButtonFrame;
  [destinationAirportButton setTitle:@"Destination airport" forState:UIControlStateNormal];
  
  UIButton *departureDateButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  CGRect departureDateButtonFrame = departureDateButton.frame;
  departureDateButtonFrame.origin = CGPointMake(halfScreenWidth - departureDateButton.frame.size.width / 2,
                                                     destinationAirportButtonFrame.origin.y + destinationAirportButtonFrame.size.height + departureDateButton.frame.size.height / 2 + 8);
  departureDateButton.frame = departureDateButtonFrame;
  [departureDateButton setTitle:@"Departure date" forState:UIControlStateNormal];
  
  UIButton *returnDateButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  CGRect returnDateButtonFrame = returnDateButton.frame;
  returnDateButtonFrame.origin = CGPointMake(halfScreenWidth - returnDateButton.frame.size.width / 2,
                                                departureDateButtonFrame.origin.y + departureDateButtonFrame.size.height + 8);
  returnDateButton.frame = returnDateButtonFrame;
  [returnDateButton setTitle:@"Return date" forState:UIControlStateNormal];
  
  UIButton *numberOfPassengersButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  CGRect numberOfPassengersButtonFrame = numberOfPassengersButton.frame;
  numberOfPassengersButtonFrame.origin = CGPointMake(halfScreenWidth - numberOfPassengersButton.frame.size.width / 2,
                                             returnDateButtonFrame.origin.y + returnDateButtonFrame.size.height + numberOfPassengersButton.frame.size.height / 2 + 8);
  numberOfPassengersButton.frame = numberOfPassengersButtonFrame;
  [numberOfPassengersButton setTitle:@"Number of passengers" forState:UIControlStateNormal];
  
  UIButton *startSearchButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  CGRect startSearchButtonFrame = startSearchButton.frame;
  startSearchButtonFrame = CGRectMake(halfScreenWidth - startSearchButton.frame.size.width / 2,
                                      numberOfPassengersButtonFrame.origin.y + numberOfPassengersButtonFrame.size.height + startSearchButton.frame.size.height / 2 + 8,
                                      startSearchButtonFrame.size.width,
                                      startSearchButtonFrame.size.height + 8);
  startSearchButton.frame = startSearchButtonFrame;
  [startSearchButton setTitle:@"Start search" forState:UIControlStateNormal];
  startSearchButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:17];
  startSearchButton.backgroundColor = [UIColor orangeColor];
  [startSearchButton setTintColor:[UIColor whiteColor]];
  
  // Place buttons
  [self.view addSubview:departureAirportButton];
  [self.view addSubview:destinationAirportButton];
  [self.view addSubview:departureDateButton];
  [self.view addSubview:returnDateButton];
  [self.view addSubview:numberOfPassengersButton];
  [self.view addSubview:startSearchButton];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kDataManagerLoadDataDidComplete
                                                object:nil];
}

@end
