//
//  SelectPlaceViewController.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 04/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "SelectPlaceViewController.h"

#define ReuseIdentifier @"PlaceCell"

@interface SelectPlaceViewController ()

@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *dataSourceArray;

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
  
  self.navigationController.navigationBar.tintColor = [UIColor blackColor];
  
  _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  [self.view addSubview:_tableView];
  
  _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Cities", @"Airports"]];
  [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
  _segmentedControl.tintColor = [UIColor blackColor];
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
      _dataSourceArray = [[DataManager sharedInstance] cities];
      break;
    case 1:
      _dataSourceArray = [[DataManager sharedInstance] airports];
      break;
    default:
      break;
  }
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  if (_segmentedControl.selectedSegmentIndex == 0) {
    City *city = [_dataSourceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = city.name;
    cell.detailTextLabel.text = city.code;
  } else if (_segmentedControl.selectedSegmentIndex == 0) {
    Airport *airport = [_dataSourceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = airport.name;
    cell.detailTextLabel.text = airport.code;
  }
  
  return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  DataSourceType dataType = ((int)_segmentedControl.selectedSegmentIndex) + 1;
  [self.delegate selectPlace:[_dataSourceArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
  [self.navigationController popViewControllerAnimated:YES];
}

@end
