//
//  CoreDataHelper.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 18/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "CoreDataHelper.h"

@interface CoreDataHelper()

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation CoreDataHelper

+ (instancetype)sharedInstance
{
  static CoreDataHelper *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [CoreDataHelper new];
    [instance setup];
  });
  return instance;
}

- (void)setup
{
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FavouriteTicket" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  
  NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
  NSURL *storeURL = [docsURL URLByAppendingPathComponent:@"base.sqlite"];
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
  
  NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
  if (!store) {
    abort();
  }
  
  _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
}

- (void)save
{
  NSError *error;
  [_managedObjectContext save: &error];
  if (error) {
    NSLog(@"%@", [error localizedDescription]);
  }
}

- (FavouriteTicket *)favouriteFromTicket:(Ticket *)ticket
{
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FavouriteTicket"];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
  return [[_managedObjectContext executeFetchRequest:fetchRequest error:nil] firstObject];
}

- (BOOL)isFavorite:(Ticket *)ticket
{
  return [self favouriteFromTicket:ticket] != nil;
}

- (void)addToFavorite:(Ticket *)ticket
{
  FavouriteTicket *favouriteTicket = [NSEntityDescription insertNewObjectForEntityForName:@"FavouriteTicket" inManagedObjectContext:_managedObjectContext];
  favouriteTicket.price = ticket.price.integerValue;
  favouriteTicket.airline = ticket.airline;
  favouriteTicket.departure = ticket.departure;
  favouriteTicket.expires = ticket.expires;
  favouriteTicket.flightNumber = ticket.flightNumber.integerValue;
  favouriteTicket.returnDate = ticket.returnDate;
  favouriteTicket.from = ticket.from;
  favouriteTicket.to = ticket.to;
  favouriteTicket.created = [NSDate date];
  [self save];
}

- (void)addPriceMapToFavorite:(PriceMap *)priceMap
{
  FavouriteTicket *favouriteTicket = [NSEntityDescription insertNewObjectForEntityForName:@"FavouriteTicket" inManagedObjectContext:_managedObjectContext];
  favouriteTicket.price = priceMap.price;
  favouriteTicket.airline = nil;
  favouriteTicket.departure = priceMap.departureDate;
  favouriteTicket.expires = nil;
  favouriteTicket.flightNumber = 0;
  favouriteTicket.returnDate = priceMap.returnDate;
  favouriteTicket.from = priceMap.origin.code;
  favouriteTicket.to = priceMap.destination.code;
  favouriteTicket.created = [NSDate date];
  [self save];
}

- (void)removeTicketFromFavorites:(Ticket *)ticket
{
  FavouriteTicket *favouriteTicket = [self favouriteFromTicket:ticket];
  if (favouriteTicket) {
    [_managedObjectContext deleteObject:favouriteTicket];
    [self save];
  }
}

- (void)removeFavouriteTicketFromFavourites:(FavouriteTicket *)favouriteTicket
{
  [_managedObjectContext deleteObject:favouriteTicket];
  [self save];
}

- (NSArray *)favourites
{
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FavouriteTicket"];
  fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
  return [_managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

@end
