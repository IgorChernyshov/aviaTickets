//
//  DataManager.h
//  aviaTickets
//
//  Created by Igor Chernyshov on 01/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "Airport.h"
#import "City.h"
#import "Country.h"

#define kDataManagerLoadDataDidComplete @"DataManagerLoadDataDidComplete"

typedef enum DataSourceType {
  DataSourceTypeCity,
  DataSourceTypeAirport,
  DataSourceTypeCountry
} DataSourceType;

@interface DataManager : NSObject

@property (nonatomic, strong, readonly) NSArray *airports;
@property (nonatomic, strong, readonly) NSArray *cities;
@property (nonatomic, strong, readonly) NSArray *countries;

+ (instancetype)sharedInstance;
- (void)loadData;
- (City *)cityForIATA:(NSString *)iata;
- (City *)cityForLocation:(CLLocation *)location;

@end
