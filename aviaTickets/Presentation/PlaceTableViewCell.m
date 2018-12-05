//
//  PlaceTableViewCell.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 05/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "PlaceTableViewCell.h"

@interface PlaceTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *codeLabel;

@end

@implementation PlaceTableViewCell

- (instancetype)initWithCity:(City *)city
{
  self = [super init];
  if (self) {
    [self configureCellView];
    _titleLabel.text = city.name;
    _codeLabel.text = city.code;
  }
  return self;
}

- (instancetype)initWithAirport:(Airport *)airport
{
  self = [super init];
  if (self) {
    [self configureCellView];
    _titleLabel.text = airport.name;
    _codeLabel.text = airport.code;
  }
  return self;
}

- (void)configureCellView
{
  // Adjust cell appearance
  self.backgroundColor = [UIColor clearColor];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  // Create labels
  _titleLabel = [UILabel new];
  _titleLabel.frame = CGRectMake(16, 4, 300, 40);
  _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17];
  _titleLabel.textColor = [UIColor whiteColor];
  [self addSubview:_titleLabel];
  
  _codeLabel = [UILabel new];
  _codeLabel.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 60, 4, 50, 40);
  _codeLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:17];
  _codeLabel.textColor = [UIColor whiteColor];
  [self addSubview:_codeLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
