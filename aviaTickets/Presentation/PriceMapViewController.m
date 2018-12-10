//
//  PriceMapViewController.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 10/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "PriceMapViewController.h"
#import "DataManager.h"
#import "APIManager.h"
#import "LocationService.h"

@interface PriceMapViewController ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;

@end

@implementation PriceMapViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Map of prices";
  
  _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
  _mapView.showsUserLocation = YES;
  [self.view addSubview:_mapView];
  
  _locationService = [LocationService new];
  
  CGRect loadingViewFrame = CGRectMake(self.view.bounds.size.width / 2.0 - 35.0,
                                        self.view.bounds.size.height / 2.0 - 35.0,
                                        70.0,
                                        70.0);
  _loadingView = [[UIView alloc] initWithFrame: loadingViewFrame];
  _loadingView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
  _loadingView.clipsToBounds = YES;
  _loadingView.layer.cornerRadius = 6.0;
  [_mapView addSubview:_loadingView];
  
  CGRect activityIndicatorFrame = CGRectMake(12.5, 12.5, 50.0, 50.0);
  UIColor *lightBlueColor = [UIColor colorWithRed:97.0/255.0
                                            green:215.0/255.0
                                             blue:255.0/255.0
                                            alpha:1];
  _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:activityIndicatorFrame];
  _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
  [_activityIndicator setColor:lightBlueColor];
  [_activityIndicator startAnimating];
  [_loadingView addSubview:_activityIndicator];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateCurrentLocation:(NSNotification *)notification
{
  CLLocation *currentLocation = notification.object;
  
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
  [_mapView setRegion:region animated:YES];
  
  if (currentLocation) {
    _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
    if (_origin) {
      [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
        self.prices = prices;
        [self->_loadingView setHidden:YES];
      }];
    }
  }
}

- (void)setPrices:(NSArray *)prices
{
  _prices = prices;
  [_mapView removeAnnotations:_mapView.annotations];
  
  for (PriceMap *price in prices) {
    dispatch_async(dispatch_get_main_queue(), ^{
      MKPointAnnotation *annotation = [MKPointAnnotation new];
      annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
      annotation.subtitle = [NSString stringWithFormat:@"%ld ₽", (long)price.price];
      annotation.coordinate = price.destination.coordinate;
      [self->_mapView addAnnotation:annotation];
    });
  }
}

@end
