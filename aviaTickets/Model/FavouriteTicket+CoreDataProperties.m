//
//  FavouriteTicket+CoreDataProperties.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 18/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//
//

#import "FavouriteTicket+CoreDataProperties.h"

@implementation FavouriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavouriteTicket *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavouriteTicket"];
}

@dynamic airline;
@dynamic created;
@dynamic departure;
@dynamic expires;
@dynamic flightNumber;
@dynamic from;
@dynamic price;
@dynamic returnDate;
@dynamic to;

@end
