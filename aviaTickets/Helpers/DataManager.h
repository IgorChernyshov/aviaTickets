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
  DataSourceTypeAirport,
  DataSourceTypeCity,
  DataSourceTypeCountry
} DataSourceType;

@interface DataManager : NSObject

+ (instancetype)sharedInstance;

- (void)loadData;

@property (nonatomic, strong, readonly) NSArray *airports;
@property (nonatomic, strong, readonly) NSArray *cities;
@property (nonatomic, strong, readonly) NSArray *countries;

@end
