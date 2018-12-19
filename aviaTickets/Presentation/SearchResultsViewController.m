//
//  SearchResultsViewController.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 03/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "TicketTableViewCell.h"
#import "CoreDataHelper.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface SearchResultsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tickets;

@end

@implementation SearchResultsViewController
{
  BOOL isFavorites;
}

- (instancetype)initFavoriteTicketsController
{
  self = [super init];
  if (self) {
    isFavorites = YES;
    _tickets = [NSArray new];
    self.title = @"Favorite Tickets";
  }
  return self;
}

- (instancetype)initWithTickets:(NSArray *)tickets
{
  self = [super init];
  if (self)
  {
    _tickets = tickets;
    self.title = @"Search results";
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Create a gradient background
  UIColor *lightBlueColor = [UIColor colorWithRed:97.0/255.0
                                            green:215.0/255.0
                                             blue:255.0/255.0
                                            alpha:1];
  UIColor *customBlueColor = [UIColor colorWithRed:72.0/255.0
                                             green:150.0/255.0
                                              blue:236.0/255.0
                                             alpha:1];
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = self.view.bounds;
  gradient.startPoint = CGPointMake(0.0, 0.0);
  gradient.endPoint = CGPointMake(1.0, 1.0);
  gradient.colors = @[(id)customBlueColor.CGColor,
                      (id)lightBlueColor.CGColor];
  [self.view.layer addSublayer:gradient];
  
  _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _tableView.backgroundColor = [UIColor clearColor];
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.delegate = self;
  _tableView.dataSource = self;
  [_tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
  [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if (isFavorites) {
    _tickets = [[CoreDataHelper sharedInstance] favorites];
    [_tableView reloadData];
  }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_tickets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
  if (isFavorites) {
    cell.favoriteTicket = [_tickets objectAtIndex:indexPath.row];
  } else {
    cell.ticket = [_tickets objectAtIndex:indexPath.row];
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (isFavorites) return;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (!isFavorites) {
    if ([[CoreDataHelper sharedInstance] isFavorite:[_tickets objectAtIndex:indexPath.row]]) {
      UITableViewRowAction *removeFromFavorites = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Remove from favorites" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[CoreDataHelper sharedInstance] removeTicketFromFavorites:self.tickets[indexPath.row]];
      }];
      return @[removeFromFavorites];
    } else {
      UITableViewRowAction *addToFavorites = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Add to favorites" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[CoreDataHelper sharedInstance] addToFavorite:self.tickets[indexPath.row]];
      }];
      addToFavorites.backgroundColor = [UIColor blueColor];
      return @[addToFavorites];
    }
  } else {
    UITableViewRowAction *removeFromFavorites = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Remove from favorites" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
      [[CoreDataHelper sharedInstance] removeFavoriteTicketFromFavorites:self.tickets[indexPath.row]];
      self.tickets = [[CoreDataHelper sharedInstance] favorites];
      [self.tableView reloadData];
    }];
    return @[removeFromFavorites];
  }
  return @[];
}

@end
