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
#import "NotificationCenter.h"
#import "NSString+Localize.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface SearchResultsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *currentTicketsArray;
@property (nonatomic, strong) NSMutableArray *filteredTicketsArray;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;

@end

@implementation SearchResultsViewController
{
  BOOL isFavorites;
  TicketTableViewCell *notificationCell;
}

- (instancetype)initFavoriteTicketsController
{
  self = [super init];
  if (self) {
    isFavorites = YES;
    _currentTicketsArray = [NSArray new];
    self.title = @"titleLabelFavoritesVC".localize;
    
    UIColor *customBlueColor = [UIColor colorWithRed:72.0/255.0
                                               green:150.0/255.0
                                                blue:236.0/255.0
                                               alpha:1];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"favoritesSegmentedControlItem1".localize, @"favoritesSegmentedControlItem2".localize, @"favoritesSegmentedControlItem3".localize]];
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
    self.title = @"titleLabelSearchResultsVC".localize;
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
  
  _datePicker = [UIDatePicker new];
  _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
  _datePicker.minimumDate = [NSDate date];
  
  _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
  _dateTextField.hidden = YES;
  _dateTextField.inputView = _datePicker;
  
  UIToolbar *keyboardToolbar = [UIToolbar new];
  [keyboardToolbar sizeToFit];
  UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonWasTapped:)];
  UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(resetNotificationSetter)];
  keyboardToolbar.items = @[cancelBarButton, flexBarButton, doneBarButton];
  
  _dateTextField.inputAccessoryView = keyboardToolbar;
  [self.view addSubview:_dateTextField];
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

- (void)resetNotificationSetter
{
  _datePicker.date = [NSDate date];
  notificationCell = nil;
  [self.view endEditing:YES];
}

- (void)doneButtonWasTapped:(UIBarButtonItem *)sender
{
  if (_datePicker.date && notificationCell) {
    NSString *message;
    if (isFavorites) {
      message = [NSString stringWithFormat:@"reminderTextForFavoriteTicket".localize, notificationCell.favoriteTicket.from, notificationCell.favoriteTicket.to, notificationCell.favoriteTicket.price];
    } else {
      message = [NSString stringWithFormat:@"reminderTextForFoundTicket".localize, notificationCell.ticket.from, notificationCell.ticket.to, notificationCell.ticket.price];
    }
    NSURL *imageURL;
    if (notificationCell.airlineLogoView.image) {
      NSString *path;
      if (isFavorites) {
        path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", notificationCell.favoriteTicket.airline]];
      } else {
        path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", notificationCell.ticket.airline]];
      }
      if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        UIImage *logo = notificationCell.airlineLogoView.image;
        NSData *pngData = UIImagePNGRepresentation(logo);
        [pngData writeToFile:path atomically:YES];
      }
      imageURL = [NSURL fileURLWithPath:path];
    }
    
    Notification notification = NotificationMake(@"Ticket reminder", message, _datePicker.date, imageURL);
    [[NotificationCenter sharedInstance] sendNotification:notification];
    
    // Convert a date from UTC to user's local time
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:_datePicker.date];

    [self resetNotificationSetter];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"doneTitle".localize message:[NSString stringWithFormat:@"reminderSetMessage".localize, dateString] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"closeButton".localize style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:closeAction];
    [self presentViewController:alertController animated:YES completion:nil];
  }
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
  UITableViewRowAction *setReminder = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"addReminderRowAction".localize handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    self->notificationCell = [tableView cellForRowAtIndexPath:indexPath];
    [self.dateTextField becomeFirstResponder];
  }];
  setReminder.backgroundColor = [UIColor orangeColor];
  if (!isFavorites) {
    if ([[CoreDataHelper sharedInstance] isFavoriteTicket:[_currentTicketsArray objectAtIndex:indexPath.row]]) {
      UITableViewRowAction *removeFromFavorites = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"removeFromFavorites".localize handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[CoreDataHelper sharedInstance] removeTicketFromFavorites:self.currentTicketsArray[indexPath.row]];
      }];
      return @[removeFromFavorites, setReminder];
    } else {
      UITableViewRowAction *addToFavorites = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"addToFavorites".localize handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[CoreDataHelper sharedInstance] addToFavorite:self.currentTicketsArray[indexPath.row]];
      }];
      addToFavorites.backgroundColor = [UIColor blueColor];
      return @[addToFavorites, setReminder];
    }
  } else {
    UITableViewRowAction *removeFromFavorites = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"removeFromFavorites".localize handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
      [[CoreDataHelper sharedInstance] removeFavoriteTicketFromFavorites:self.currentTicketsArray[indexPath.row]];
      self.currentTicketsArray = [[CoreDataHelper sharedInstance] favorites];
      [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
    }];
    return @[removeFromFavorites, setReminder];
  }
  return @[];
}

@end
