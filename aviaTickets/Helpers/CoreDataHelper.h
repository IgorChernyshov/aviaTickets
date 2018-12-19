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
#import "FavouriteTicket+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray *)favourites;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;

@end

NS_ASSUME_NONNULL_END
