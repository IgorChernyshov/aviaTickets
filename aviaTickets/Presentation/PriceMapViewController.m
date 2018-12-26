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
#import "CoreDataHelper.h"
#import "LoadingView.h"
#import "NSString+Localize.h"

@interface PriceMapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;

@end

@implementation PriceMapViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"titleLabel".localize;
  
  _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
  _mapView.delegate = self;
  _mapView.showsUserLocation = YES;
  [self.view addSubview:_mapView];
  
  _locationService = [LocationService new];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

- (void)updateCurrentLocation:(NSNotification *)notification
{
  CLLocation *currentLocation = notification.object;
  
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
  [_mapView setRegion:region animated:YES];
  
  if (currentLocation) {
    _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
    if (_origin) {
      [[LoadingView sharedInstance] show:^{
        [[APIManager sharedInstance] mapPricesFor:self.origin withCompletion:^(NSArray *prices) {
          [[LoadingView sharedInstance] dismiss:^{
            self.prices = prices;
          }];
        }];
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
      [self.mapView addAnnotation:annotation];
    });
  }
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
  // Search for selected ticket in prices array
  NSString *annotationTitle = [NSString stringWithFormat:@"%@", view.annotation.title];
  PriceMap *selectedMarkData;
  for (PriceMap *price in _prices) {
    NSString *stringForSearch = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
    if ([annotationTitle isEqualToString:stringForSearch] && ![[CoreDataHelper sharedInstance] isFavoritePriceMap:price]) {
      selectedMarkData = price;
      [[CoreDataHelper sharedInstance] addPriceMapToFavorite:selectedMarkData];
      return;
    }
  }
}

@end
