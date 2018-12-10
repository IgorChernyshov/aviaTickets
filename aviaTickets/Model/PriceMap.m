//
//  PriceMap.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 10/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "PriceMap.h"

@implementation PriceMap

- (instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin: (City *)origin
{
  self = [super init];
  if (self) {
    _destination = [[DataManager sharedInstance] cityForIATA:[dictionary valueForKey:@"destination"]];
    _origin = origin;
    _departureDate = [self dateFromString:[dictionary valueForKey:@"depart_date"]];
    _returnDate = [self dateFromString:[dictionary valueForKey:@"return_date"]];
    _numberOfTransfers = [[dictionary valueForKey:@"number_of_changes"] integerValue];
    _price = [[dictionary valueForKey:@"value"] integerValue];
    _distance = [[dictionary valueForKey:@"distance"] integerValue];
    _actual = [[dictionary valueForKey:@"actual"] boolValue];
  }
  return self;
}

- (NSDate * _Nullable)dateFromString:(NSString *)dateString {
  if (!dateString) { return  nil; }
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yyyy-MM-dd";
  return [dateFormatter dateFromString: dateString];
}

@end
