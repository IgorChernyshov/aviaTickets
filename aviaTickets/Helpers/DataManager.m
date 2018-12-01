//
//  DataManager.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 01/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()

@property (nonatomic, strong) NSMutableArray *airportsArray;
@property (nonatomic, strong) NSMutableArray *citiesArray;
@property (nonatomic, strong) NSMutableArray *countriesArray;

@end

@implementation DataManager

+ (instancetype)sharedInstance {
  static DataManager *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [DataManager new];
  });
  return instance;
}

- (void)loadData {
  dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
    NSArray *airportsJSONArray = [self arrayFromFileName:@"airports" ofType:@"json"];
    self->_airportsArray = [self createObjectsFromArray:airportsJSONArray withType:DataSourceTypeAirport];
    NSArray *citiesJSONArray = [self arrayFromFileName:@"cities" ofType:@"json"];
    self->_citiesArray = [self createObjectsFromArray:citiesJSONArray withType:DataSourceTypeCity];
    NSArray *countriesJSONArray = [self arrayFromFileName:@"countries" ofType:@"json"];
    self->_countriesArray = [self createObjectsFromArray:countriesJSONArray withType:DataSourceTypeCountry];
    dispatch_async(dispatch_get_main_queue(), ^{
      [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerLoadDataDidComplete
                                                          object:nil];
    });
  });
}

- (NSMutableArray *)createObjectsFromArray:(NSArray *)array withType:(DataSourceType)type {
  NSMutableArray *results = [NSMutableArray new];
  for (NSDictionary *jsonObject in array) {
    if (type == DataSourceTypeAirport) {
      Airport *airport = [[Airport alloc] initWithDictionary:jsonObject];
      [results addObject:airport];
    } else if (type == DataSourceTypeCity) {
      City *city = [[City alloc] initWithDictionary:jsonObject];
      [results addObject:city];
    } else if (type == DataSourceTypeCountry) {
      Country *country = [[Country alloc] initWithDictionary:jsonObject];
      [results addObject:country];
    }
  }
  return results;
}

- (NSArray *)arrayFromFileName:(NSString *)fileName ofType:(NSString *)type {
  NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
  NSData *data = [NSData dataWithContentsOfFile:path];
  return [NSJSONSerialization JSONObjectWithData:data
                                         options:NSJSONReadingMutableContainers
                                           error:nil];
}

- (NSArray *) airports {
  return _airportsArray;
}

- (NSArray *) cities {
  return _citiesArray;
}

- (NSArray *) countries {
  return _countriesArray;
}

@end
