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
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FavoriteTicket" withExtension:@"momd"];
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

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket
{
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
  return [[_managedObjectContext executeFetchRequest:fetchRequest error:nil] firstObject];
}

- (BOOL)isFavoriteTicket:(Ticket *)ticket
{
  return [self favoriteFromTicket:ticket] != nil;
}

- (void)addToFavorite:(Ticket *)ticket
{
  FavoriteTicket *favoriteTicket = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:_managedObjectContext];
  favoriteTicket.price = ticket.price.integerValue;
  favoriteTicket.airline = ticket.airline;
  favoriteTicket.departure = ticket.departure;
  favoriteTicket.expires = ticket.expires;
  favoriteTicket.flightNumber = ticket.flightNumber.integerValue;
  favoriteTicket.returnDate = ticket.returnDate;
  favoriteTicket.from = ticket.from;
  favoriteTicket.to = ticket.to;
  favoriteTicket.created = [NSDate date];
  [self save];
}

- (FavoriteTicket *)favoriteFromPriceMap:(PriceMap *)priceMap
{
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND from == %@ AND to == %@ AND departure == %@", (long)priceMap.price, priceMap.origin.code, priceMap.destination.code, priceMap.departureDate];
  return [[_managedObjectContext executeFetchRequest:fetchRequest error:nil] firstObject];
}

- (BOOL)isFavoritePriceMap:(PriceMap *)priceMap
{
  return [self favoriteFromPriceMap:priceMap] != nil;
}

- (void)addPriceMapToFavorite:(PriceMap *)priceMap
{
  FavoriteTicket *favoriteTicket = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:_managedObjectContext];
  favoriteTicket.price = priceMap.price;
  favoriteTicket.airline = nil;
  favoriteTicket.departure = priceMap.departureDate;
  favoriteTicket.expires = nil;
  favoriteTicket.flightNumber = 0;
  favoriteTicket.returnDate = priceMap.returnDate;
  favoriteTicket.from = priceMap.origin.code;
  favoriteTicket.to = priceMap.destination.code;
  favoriteTicket.created = [NSDate date];
  [self save];
}

- (void)removeTicketFromFavorites:(Ticket *)ticket
{
  FavoriteTicket *favoriteTicket = [self favoriteFromTicket:ticket];
  if (favoriteTicket) {
    [_managedObjectContext deleteObject:favoriteTicket];
    [self save];
  }
}

- (void)removeFavoriteTicketFromFavorites:(FavoriteTicket *)favoriteTicket
{
  [_managedObjectContext deleteObject:favoriteTicket];
  [self save];
}

- (NSArray *)favorites
{
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
  fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
  return [_managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

@end
