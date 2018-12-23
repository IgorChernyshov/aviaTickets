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
#import "PriceMapViewController.h"

// Import helpers
#import "DataManager.h"
#import "APIManager.h"

// Import custom view elements
#import "MainViewButton.h"


@interface MainViewController () <SelectPlaceViewControllerDelegate>

@property (nonatomic, strong) UIView *locationButtonsView;
@property (nonatomic, strong) UIView *datesButtonsView;
@property (nonatomic, strong) MainViewButton *departFromButton;
@property (nonatomic, strong) MainViewButton *arriveToButton;
@property (nonatomic, strong) MainViewButton *departureDateButton;
@property (nonatomic, strong) MainViewButton *returnDateButton;
@property (nonatomic, strong) MainViewButton *startSearchButton;
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
  self.navigationController.navigationBar.prefersLargeTitles = YES;
  
  self.activityIndicator = [self createActivityIndicator];
  [self.view addSubview:_activityIndicator];
  
  // Create a notification subscription to know when data has been loaded
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(initializeUI)
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

- (void)initializeUI
{
  // Indicate that app is ready
  [self.activityIndicator removeFromSuperview];
  
  // Configure navigation bar
  self.title = @"Search Tickets";
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
  
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
  CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height +
                          (self.navigationController.navigationBar.frame.size.height));
  
  // Create a view and buttons that control locations
  _locationButtonsView = [[UIView alloc] initWithFrame:CGRectMake(40.0, topbarHeight + 20.0, [UIScreen mainScreen].bounds.size.width - 80.0, 100.0)];
  _locationButtonsView.backgroundColor = [UIColor whiteColor];
  _locationButtonsView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.3] CGColor];
  _locationButtonsView.layer.shadowOffset = CGSizeZero;
  _locationButtonsView.layer.shadowRadius = 10.0;
  _locationButtonsView.layer.shadowOpacity = 1.0;
  _locationButtonsView.layer.cornerRadius = 6.0;
  [self.view addSubview:_locationButtonsView];
  
  _departFromButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  [_departFromButton setTitle:@"Depart from" forState:UIControlStateNormal];
  [_departFromButton addTarget:self action:@selector(placeButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
  CGRect departFromButtonFrame = _departFromButton.frame;
  departFromButtonFrame.origin = CGPointMake(10.0, 10.0);
  _departFromButton.frame = departFromButtonFrame;
  
  _arriveToButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  [_arriveToButton setTitle:@"Arrive to" forState:UIControlStateNormal];
  [_arriveToButton addTarget:self action:@selector(placeButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
  CGRect arriveToButtonFrame = _arriveToButton.frame;
  arriveToButtonFrame.origin = CGPointMake(10.0, CGRectGetMaxY(departFromButtonFrame) + 10.0);
  _arriveToButton.frame = arriveToButtonFrame;
  
  // Create a view and buttons that control dates
  _datesButtonsView = [[UIView alloc] initWithFrame:CGRectMake(40.0, CGRectGetMaxY(_locationButtonsView.frame) + 20.0, [UIScreen mainScreen].bounds.size.width - 80.0, 100.0)];
  _datesButtonsView.backgroundColor = [UIColor whiteColor];
  _datesButtonsView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.3] CGColor];
  _datesButtonsView.layer.shadowOffset = CGSizeZero;
  _datesButtonsView.layer.shadowRadius = 10.0;
  _datesButtonsView.layer.shadowOpacity = 1.0;
  _datesButtonsView.layer.cornerRadius = 6.0;
  [self.view addSubview:_datesButtonsView];
  
  _departureDateButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  [_departureDateButton setTitle:@"Departure date" forState:UIControlStateNormal];
  CGRect departureDateButtonFrame = _departureDateButton.frame;
  departureDateButtonFrame.origin = CGPointMake(10.0, 10.0);
  _departureDateButton.frame = departureDateButtonFrame;
  
  _returnDateButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  [_returnDateButton setTitle:@"Return date" forState:UIControlStateNormal];
  CGRect returnDateButtonFrame = _returnDateButton.frame;
  returnDateButtonFrame.origin = CGPointMake(10.0, CGRectGetMaxY(departureDateButtonFrame) + 10.0);
  _returnDateButton.frame = returnDateButtonFrame;
  
  MainViewButton *numberOfPassengersButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  [numberOfPassengersButton setTitle:@"Number of passengers" forState:UIControlStateNormal];
  numberOfPassengersButton.frame = CGRectMake(40.0,
                                              CGRectGetMaxY(_datesButtonsView.frame) + 20.0,
                                              [UIScreen mainScreen].bounds.size.width - 80.0,
                                              numberOfPassengersButton.frame.size.height + 8.0);
  numberOfPassengersButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
  
  _startSearchButton = [MainViewButton buttonWithType:UIButtonTypeSystem];
  _startSearchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  [_startSearchButton setTitle:@"Start search" forState:UIControlStateNormal];
  _startSearchButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:17];
  _startSearchButton.backgroundColor = [UIColor orangeColor];
  [_startSearchButton setTintColor:[UIColor whiteColor]];
  _startSearchButton.frame = CGRectMake(40.0,
                                        CGRectGetMaxY(numberOfPassengersButton.frame) + 20.0,
                                        [UIScreen mainScreen].bounds.size.width - 80.0,
                                        _startSearchButton.frame.size.height + 8.0);
  
  // Assign actions to buttons
  [_startSearchButton addTarget:self
                         action:@selector(startSearchButtonWasPressed)
               forControlEvents:UIControlEventTouchUpInside];
  
  // Place buttons
  [_locationButtonsView addSubview:_departFromButton];
  [_locationButtonsView addSubview:_arriveToButton];
  [_datesButtonsView addSubview:_departureDateButton];
  [_datesButtonsView addSubview:_returnDateButton];
  [self.view addSubview:numberOfPassengersButton];
  [self.view addSubview:_startSearchButton];
  
  // Request current user's location from APIManager
  [[APIManager sharedInstance] cityForCurrentIP:^(City *city) {
    [self setPlace:city withDataType:DataSourceTypeCity andPlaceType:PlaceTypeDeparture forButton:self.departFromButton];
  }];
}

- (void)placeButtonWasPressed:(MainViewButton *)sender {
  SelectPlaceViewController *selectPlaceViewController;
  if ([sender isEqual:_departFromButton]) {
    selectPlaceViewController = [[SelectPlaceViewController alloc] initWithType:PlaceTypeDeparture];
  } else {
    selectPlaceViewController = [[SelectPlaceViewController alloc] initWithType:PlaceTypeArrival];
  }
  selectPlaceViewController.delegate = self;
  [self.navigationController pushViewController:selectPlaceViewController animated:YES];
}

- (void)priceMapButtonWasPressed
{
  PriceMapViewController *priceMapViewController = [PriceMapViewController new];
  [self.navigationController pushViewController:priceMapViewController animated:YES];
}

- (void)startSearchButtonWasPressed
{
  if (![_departFromButton.titleLabel.text isEqual: @"Depart from"] && ![_arriveToButton.titleLabel.text isEqual: @"Arrive to"]) {
    [[APIManager sharedInstance] ticketsWithRequest:_searchRequest withCompletion:^(NSArray *tickets) {
      if (tickets.count > 0) {
        SearchResultsViewController *searchResultsViewController = [[SearchResultsViewController alloc] initWithTickets:tickets];
        [self.navigationController pushViewController:searchResultsViewController animated:YES];
      } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Whoops!" message:@"No tickets found with these parameters" preferredStyle: UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
      }
    }];
  } else {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"You need to set both Departure and Arrival place to search tickets" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
  }
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
