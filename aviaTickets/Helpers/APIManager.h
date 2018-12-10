//
//  APIManager.h
//  aviaTickets
//
//  Created by Igor Chernyshov on 08/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "MainViewController.h"
#import "Ticket.h"
#import "PriceMap.h"

@interface APIManager : NSObject

+ (instancetype)sharedInstance;
- (void)cityForCurrentIP:(void (^)(City *city))completion;
- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;
- (void)mapPricesFor:(City *)origin withCompletion:(void(^)(NSArray *prices))completion;

@end
