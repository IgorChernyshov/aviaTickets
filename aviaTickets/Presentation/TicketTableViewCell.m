//
//  TicketTableViewCell.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 08/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "TicketTableViewCell.h"
#import <YYWebImage/YYWebImage.h>

#define AirlineLogo(iata) [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avs.io/200/200/%@.png", iata]];

@interface TicketTableViewCell ()
@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *placesLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation TicketTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self configureCell];
  }
  return self;
}

- (void)configureCell
{
  self.backgroundColor = [UIColor clearColor];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  self.contentView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
  self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
  self.contentView.layer.shadowRadius = 10.0;
  self.contentView.layer.shadowOpacity = 1.0;
  self.contentView.layer.cornerRadius = 6.0;
  self.contentView.backgroundColor = [UIColor whiteColor];
  
  _priceLabel = [[UILabel alloc] initWithFrame:self.bounds];
  _priceLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:24.0];
  [self.contentView addSubview:_priceLabel];
  
  _airlineLogoView = [[UIImageView alloc] initWithFrame:self.bounds];
  _airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
  [self.contentView addSubview:_airlineLogoView];
  
  _placesLabel = [[UILabel alloc] initWithFrame:self.bounds];
  _placesLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:15.0];
  _placesLabel.textColor = [UIColor darkGrayColor];
  [self.contentView addSubview:_placesLabel];
  
  _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
  _dateLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:15.0];
  [self.contentView addSubview:_dateLabel];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  self.contentView.frame = CGRectMake(10.0, 10.0, [UIScreen mainScreen].bounds.size.width - 20.0, self.frame.size.height - 20.0);
  _priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - 110.0, 40.0);
  _airlineLogoView.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame) + 10.0, 10.0, 80.0, 80.0);
  _placesLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_priceLabel.frame) + 16.0, 100.0, 20.0);
  _dateLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_placesLabel.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)setTicket:(Ticket *)ticket {
  _ticket = ticket;
  
  _priceLabel.text = [NSString stringWithFormat:@"%@ ₽", ticket.price];
  _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
  _dateLabel.text = [dateFormatter stringFromDate:ticket.departure];
  NSURL *urlLogo = AirlineLogo(ticket.airline);
  [_airlineLogoView yy_setImageWithURL:urlLogo options:YYWebImageOptionSetImageWithFadeAnimation];
}

- (void)setFavouriteTicket:(FavouriteTicket *)favouriteTicket
{
  _favouriteTicket = favouriteTicket;
  
  _priceLabel.text = [NSString stringWithFormat:@"%lld ₽", favouriteTicket.price];
  _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", favouriteTicket.from, favouriteTicket.to];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
  _dateLabel.text = [dateFormatter stringFromDate:favouriteTicket.departure];
  NSURL *urlLogo = AirlineLogo(favouriteTicket.airline);
  [_airlineLogoView yy_setImageWithURL:urlLogo options:YYWebImageOptionSetImageWithFadeAnimation];
}

@end
