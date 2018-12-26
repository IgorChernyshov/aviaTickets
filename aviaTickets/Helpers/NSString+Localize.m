//
//  NSString+Localize.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 26/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "NSString+Localize.h"

@implementation NSString (Localize)

- (NSString *)localize {
  return NSLocalizedString(self, "");
}

@end
