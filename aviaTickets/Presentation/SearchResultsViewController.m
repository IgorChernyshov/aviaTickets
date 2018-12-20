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
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *currentTicketsArray;
@property (nonatomic, strong) NSMutableArray *filteredTicketsArray;

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
    _currentTicketsArray = [NSArray new];
    self.title = @"Favorite Tickets";
    
    UIColor *customBlueColor = [UIColor colorWithRed:72.0/255.0
                                               green:150.0/255.0
                                                blue:236.0/255.0
                                               alpha:1];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"All Tickets", @"From Search", @"From Map"]];
    [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = customBlueColor;
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
  }
  return self;
}

- (instancetype)initWithTickets:(NSArray *)tickets
{
  self = [super init];
  if (self)
  {
    _currentTicketsArray = tickets;
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
    [self changeSource];
  }
}

- (void)changeSource
{
  _currentTicketsArray = [[CoreDataHelper sharedInstance] favorites];
  switch (_segmentedControl.selectedSegmentIndex) {
    case 1:
      _filteredTicketsArray = [NSMutableArray new];
      for (FavoriteTicket *ticket in _currentTicketsArray) {
        if (ticket.airline) {
          [_filteredTicketsArray addObject:ticket];
        }
      }
      _currentTicketsArray = [_filteredTicketsArray copy];
      break;
    case 2:
      _filteredTicketsArray = [NSMutableArray new];
      for (FavoriteTicket *ticket in _currentTicketsArray) {
        if (!ticket.airline) {
          [_filteredTicketsArray addObject:ticket];
        }
      }
      _currentTicketsArray = [_filteredTicketsArray copy];
      break;
    default:
      // All Tickets control selected
      break;
  }
  [_tableView reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_currentTicketsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
  if (isFavorites) {
    cell.favoriteTicket = [_currentTicketsArray objectAtIndex:indexPath.row];
  } else {
    cell.ticket = [_currentTicketsArray objectAtIndex:indexPath.row];
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
    if ([[CoreDataHelper sharedInstance] isFavorite:[_currentTicketsArray objectAtIndex:indexPath.row]]) {
      UITableViewRowAction *removeFromFavorites = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Remove from favorites" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[CoreDataHelper sharedInstance] removeTicketFromFavorites:self.currentTicketsArray[indexPath.row]];
      }];
      return @[removeFromFavorites];
    } else {
      UITableViewRowAction *addToFavorites = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Add to favorites" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[CoreDataHelper sharedInstance] addToFavorite:self.currentTicketsArray[indexPath.row]];
      }];
      addToFavorites.backgroundColor = [UIColor blueColor];
      return @[addToFavorites];
    }
  } else {
    UITableViewRowAction *removeFromFavorites = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Remove from favorites" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
      [[CoreDataHelper sharedInstance] removeFavoriteTicketFromFavorites:self.currentTicketsArray[indexPath.row]];
      self.currentTicketsArray = [[CoreDataHelper sharedInstance] favorites];
      [self.tableView reloadData];
    }];
    return @[removeFromFavorites];
  }
  return @[];
}

@end
