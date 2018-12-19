//
//  CoreDataHelper.h
//  aviaTickets
//
//  Created by Igor Chernyshov on 18/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "DataManager.h"
#import "Ticket.h"
#import "PriceMap.h"
#import "FavoriteTicket+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray *)favorites;
- (void)addToFavorite:(Ticket *)ticket;
- (void)addPriceMapToFavorite:(PriceMap *)priceMap;
- (void)removeTicketFromFavorites:(Ticket *)ticket;
- (void)removeFavoriteTicketFromFavorites:(FavoriteTicket *)favoriteTicket;

@end

NS_ASSUME_NONNULL_END
