//
//  PriceMap.h
//  aviaTickets
//
//  Created by Igor Chernyshov on 10/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"
#import "DataManager.h"

@interface PriceMap : NSObject

@property (strong, nonatomic) City *destination;
@property (strong, nonatomic) City *origin;
@property (strong, nonatomic) NSDate *departureDate;
@property (strong, nonatomic) NSDate *returnDate;
@property (nonatomic) NSInteger numberOfTransfers;
@property (nonatomic) NSInteger price;
@property (nonatomic) NSInteger distance;
@property (nonatomic) BOOL actual;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin: (City *)origin;

@end
