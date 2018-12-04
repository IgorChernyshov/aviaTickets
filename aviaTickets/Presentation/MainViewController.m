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
#import "SelectPlaceViewController.h"

// Import helpers
#import "DataManager.h"

// Import custom view elements
#import "MainViewButton.h"

@interface MainViewController () <SelectPlaceViewControllerDelegate>

@property (nonatomic, strong) MainViewButton *departFromButton;
@property (nonatomic, strong) MainViewButton *arriveToButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) SearchRequest searchRequest;

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
  self.navigationController.navigationBar.prefersLargeTitles = YES;
  self.title = @"Search tickets";
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
  CGFloat halfScreenWidth = [UIScreen mainScreen].bounds.size.width / 2;
  CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height +
                          (self.navigationController.navigationBar.frame.size.height));
  
  // Create buttons
  _departFromButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  [_departFromButton setTitle:@"Depart from" forState:UIControlStateNormal];
  [_departFromButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
  CGRect departFromButtonFrame = _departFromButton.frame;
  departFromButtonFrame.origin = CGPointMake(halfScreenWidth - _departFromButton.frame.size.width / 2,
                                    topbarHeight + _departFromButton.frame.size.height / 2);
  _departFromButton.frame = departFromButtonFrame;
  
  _arriveToButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  [_arriveToButton setTitle:@"Arrive to" forState:UIControlStateNormal];
  [_arriveToButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
  CGRect arriveToButtonFrame = _arriveToButton.frame;
  arriveToButtonFrame.origin = CGPointMake(halfScreenWidth - _arriveToButton.frame.size.width / 2,
                                                   departFromButtonFrame.origin.y + departFromButtonFrame.size.height + 8);
  _arriveToButton.frame = arriveToButtonFrame;
  
  MainViewButton *departureDateButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  [departureDateButton setTitle:@"Departure date" forState:UIControlStateNormal];
  CGRect departureDateButtonFrame = departureDateButton.frame;
  departureDateButtonFrame.origin = CGPointMake(halfScreenWidth - departureDateButton.frame.size.width / 2,
                                                     arriveToButtonFrame.origin.y + arriveToButtonFrame.size.height + departureDateButton.frame.size.height / 2 + 8);
  departureDateButton.frame = departureDateButtonFrame;
  
  MainViewButton *returnDateButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
    [returnDateButton setTitle:@"Return date" forState:UIControlStateNormal];
  CGRect returnDateButtonFrame = returnDateButton.frame;
  returnDateButtonFrame.origin = CGPointMake(halfScreenWidth - returnDateButton.frame.size.width / 2,
                                                departureDateButtonFrame.origin.y + departureDateButtonFrame.size.height + 8);
  returnDateButton.frame = returnDateButtonFrame;
  
  MainViewButton *numberOfPassengersButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  [numberOfPassengersButton setTitle:@"Number of passengers" forState:UIControlStateNormal];
  CGRect numberOfPassengersButtonFrame = numberOfPassengersButton.frame;
  numberOfPassengersButtonFrame.origin = CGPointMake(halfScreenWidth - numberOfPassengersButton.frame.size.width / 2,
                                             returnDateButtonFrame.origin.y + returnDateButtonFrame.size.height + numberOfPassengersButton.frame.size.height / 2 + 8);
  numberOfPassengersButton.frame = numberOfPassengersButtonFrame;
  
  MainViewButton *startSearchButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  startSearchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  [startSearchButton setTitle:@"Start search" forState:UIControlStateNormal];
  startSearchButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:17];
  startSearchButton.backgroundColor = [UIColor orangeColor];
  [startSearchButton setTintColor:[UIColor whiteColor]];
  CGRect startSearchButtonFrame = startSearchButton.frame;
  startSearchButtonFrame = CGRectMake(halfScreenWidth - startSearchButton.frame.size.width / 2,
                                      numberOfPassengersButtonFrame.origin.y + numberOfPassengersButtonFrame.size.height + startSearchButton.frame.size.height / 2 + 8,
                                      startSearchButtonFrame.size.width,
                                      startSearchButtonFrame.size.height + 8);
  startSearchButton.frame = startSearchButtonFrame;
  
  // Assign actions to buttons
  [startSearchButton addTarget:self
                        action:@selector(startSearchButtonWasPressed)
              forControlEvents:UIControlEventTouchUpInside];
  
  // Place buttons
  [self.view addSubview:_departFromButton];
  [self.view addSubview:_arriveToButton];
  [self.view addSubview:departureDateButton];
  [self.view addSubview:returnDateButton];
  [self.view addSubview:numberOfPassengersButton];
  [self.view addSubview:startSearchButton];
}

- (void)placeButtonDidTap:(MainViewButton *)sender {
  SelectPlaceViewController *selectPlaceViewController;
  if ([sender isEqual:_departFromButton]) {
    selectPlaceViewController = [[SelectPlaceViewController alloc] initWithType:PlaceTypeDeparture];
  } else {
    selectPlaceViewController = [[SelectPlaceViewController alloc] initWithType:PlaceTypeArrival];
  }
  selectPlaceViewController.delegate = self;
  [self.navigationController pushViewController:selectPlaceViewController animated:YES];
}

- (void)startSearchButtonWasPressed
{
  SearchResultsViewController *searchResultsViewController = [[SearchResultsViewController alloc] initWithNibName:nil bundle:nil];
  [self.navigationController pushViewController:searchResultsViewController animated:YES];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kDataManagerLoadDataDidComplete
                                                object:nil];
}

#pragma mark - PlaceViewControllerDelegate

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType
{
  [self setPlace:place withDataType:dataType andPlaceType:placeType forButton: (placeType == PlaceTypeDeparture) ? _departFromButton : _arriveToButton];
}

- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(MainViewButton *)button
{
  NSString *title;
  NSString *iataCode;
  if (dataType == DataSourceTypeCity) {
    City *city = (City *)place;
    title = city.name;
    iataCode = city.code;
  } else if (dataType == DataSourceTypeAirport) {
    Airport *airport = (Airport *)place;
    title = airport.name;
    iataCode = airport.code;
  }
  if (placeType == PlaceTypeDeparture) {
    _searchRequest.origin = iataCode;
  } else {
    _searchRequest.destination = iataCode;
  }
  [button setTitle:title forState:UIControlStateNormal];
}

@end
