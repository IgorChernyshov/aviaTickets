//
//  Country.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 01/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "Country.h"

@implementation Country

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
  self = [super init];
  if (self) {
    _currency = [dictionary valueForKey:@"currency"];
    _translations = [dictionary valueForKey:@"name_translations"];
    _name = [dictionary valueForKey:@"name"];
    _code = [dictionary valueForKey:@"code"];
    
    [self localizeName];
  }
  return self;
}

- (void)localizeName {
  if (!_translations) return;
  NSLocale *locale = [NSLocale currentLocale];
  NSString *localeId = [locale.localeIdentifier substringToIndex:2];
  if (localeId) {
    if ([_translations valueForKey: localeId]) {
      self.name = [_translations valueForKey: localeId];
    }
  }
}

@end
