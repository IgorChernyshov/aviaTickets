//
//  PlaceTableViewCell.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 05/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "PlaceTableViewCell.h"

@implementation PlaceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self configureCellView];
  }
  return self;
}

- (void)configureCellView
{
  // Adjust cell appearance
  self.backgroundColor = [UIColor clearColor];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  // Create labels
  _nameLabel = [UILabel new];
  _nameLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17];
  _nameLabel.textColor = [UIColor whiteColor];
  [self.contentView addSubview:_nameLabel];
  
  _codeLabel = [UILabel new];
  _codeLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:17];
  _codeLabel.textColor = [UIColor whiteColor];
  [self.contentView addSubview:_codeLabel];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  CGFloat labelHeight = 30.0;
  CGRect nameLabelFrame = CGRectMake(16, self.frame.size.height / 2 - labelHeight / 2, 300, labelHeight);
  _nameLabel.frame = nameLabelFrame;
  CGRect codeLabelFrame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 60, self.frame.size.height / 2 - labelHeight / 2, 50, labelHeight);
  _codeLabel.frame = codeLabelFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
