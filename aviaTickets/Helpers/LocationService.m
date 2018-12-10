//
//  LocationService.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 10/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "LocationService.h"

@interface LocationService() <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end

@implementation LocationService

- (instancetype)init
{
  self = [super init];
  if (self) {
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    [_locationManager requestWhenInUseAuthorization];
  }
  return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
  if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
    [_locationManager startUpdatingLocation];
  } else if (status != kCLAuthorizationStatusNotDetermined) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Whoops!" message:@"We don't have permissions to detect your location" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
  }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
  if (!_currentLocation) {
    _currentLocation = [locations firstObject];
    [_locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceDidUpdateCurrentLocation object:_currentLocation];
  }
}

@end
