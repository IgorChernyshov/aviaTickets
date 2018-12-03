//
//  City.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 01/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "City.h"

@implementation City

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
  self = [super init];
  if (self) {
    _timezone = [dictionary valueForKey:@"time_zone"];
    _translations = [dictionary valueForKey:@"name_translations"];
    _name = [dictionary valueForKey:@"name"];
    _countryCode = [dictionary valueForKey:@"country_code"];
    _code = [dictionary valueForKey:@"code"];
    NSDictionary *coordinates = [dictionary valueForKey:@"coordinates"];
    if (coordinates && ![coordinates isEqual:[NSNull null]]) {
      NSNumber *lon = [coordinates valueForKey:@"lon"];
      NSNumber *lat = [coordinates valueForKey:@"lat"];
      if (![lon isEqual:[NSNull null]] && ![lat isEqual:[NSNull null]]) {
        _coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
      }
    }
  }
  return self;
}
@end
