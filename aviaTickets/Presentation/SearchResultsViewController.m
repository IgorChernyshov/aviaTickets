//
//  SearchResultsViewController.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 03/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "TicketTableViewCell.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface SearchResultsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tickets;

@end

@implementation SearchResultsViewController

- (instancetype)initWithTickets:(NSArray *)tickets
{
  self = [super init];
  if (self)
  {
    _tickets = tickets;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Search results";
  
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

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_tickets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
  cell.ticket = [_tickets objectAtIndex:indexPath.row];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 140.0;
}

@end
