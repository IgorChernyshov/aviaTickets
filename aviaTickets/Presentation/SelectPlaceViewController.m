//
//  SelectPlaceViewController.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 04/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "SelectPlaceViewController.h"
#import "PlaceTableViewCell.h"

#define ReuseIdentifier @"PlaceCell"

@interface SelectPlaceViewController () <UISearchResultsUpdating>

@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *currentDataArray;
@property (nonatomic, strong) NSArray *searchResultsDataArray;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation SelectPlaceViewController

- (instancetype)initWithType:(PlaceType)type
{
  self = [super init];
  if (self) {
    _placeType = type;
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
  
  self.navigationController.navigationBar.tintColor = customBlueColor;
  
  _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
  _searchController.dimsBackgroundDuringPresentation = NO;
  _searchController.searchResultsUpdater = self;
  _searchResultsDataArray = [NSArray new];
  
  _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _tableView.backgroundColor = [UIColor clearColor];
  _tableView.separatorColor = [UIColor whiteColor];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  if (@available(iOS 11.0, *)) {
    self.navigationItem.searchController = _searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
  } else {
    _tableView.tableHeaderView = _searchController.searchBar;
  }
  [_tableView registerClass:[PlaceTableViewCell class] forCellReuseIdentifier:ReuseIdentifier];
  [self.view addSubview:_tableView];
  
  _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Cities", @"Airports"]];
  [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
  _segmentedControl.tintColor = customBlueColor;
  self.navigationItem.titleView = _segmentedControl;
  _segmentedControl.selectedSegmentIndex = 0;
  [self changeSource];
  
  if (_placeType == PlaceTypeDeparture) {
    self.title = @"Depart from";
  } else {
    self.title = @"Arrive to";
  }
}

- (void)changeSource
{
  switch (_segmentedControl.selectedSegmentIndex) {
    case 0:
      _currentDataArray = [[DataManager sharedInstance] cities];
      break;
    case 1:
      _currentDataArray = [[DataManager sharedInstance] airports];
      break;
    default:
      break;
  }
  [self.tableView reloadData];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
  if (searchController.searchBar.text) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", searchController.searchBar.text];
    _searchResultsDataArray = [_currentDataArray filteredArrayUsingPredicate:predicate];
    [_tableView reloadData];
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (_searchController.isActive && ![_searchController.searchBar.text isEqualToString:@""]) {
    return _searchResultsDataArray.count;
  }
  return [_currentDataArray count];
}

- (PlaceTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
  id item = (_searchController.isActive && ![_searchController.searchBar.text isEqualToString:@""]) ? [_searchResultsDataArray objectAtIndex:indexPath.row] : [_currentDataArray objectAtIndex:indexPath.row];
  if (_segmentedControl.selectedSegmentIndex == 0) {
    City *city = item;
    cell.nameLabel.text = city.name;
    cell.codeLabel.text = city.code;
  } else if (_segmentedControl.selectedSegmentIndex == 1) {
    Airport *airport = item;
    cell.nameLabel.text = airport.name;
    cell.codeLabel.text = airport.code;
  }
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  DataSourceType dataType = (int)_segmentedControl.selectedSegmentIndex;
  if (_searchController.isActive && ![_searchController.searchBar.text isEqualToString:@""]) {
    [self.delegate selectPlace:[_searchResultsDataArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
    _searchController.active = NO;
  } else {
    [self.delegate selectPlace:[_currentDataArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 48.0 ;
}

@end
