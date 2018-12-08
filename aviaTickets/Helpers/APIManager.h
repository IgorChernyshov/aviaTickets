//
//  APIManager.h
//  aviaTickets
//
//  Created by Igor Chernyshov on 08/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface APIManager : NSObject

+ (instancetype)sharedInstance;
- (void)cityForCurrentIP:(void (^)(City *city))completion;

@end
