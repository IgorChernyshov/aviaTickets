//
//  MainViewButton.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 02/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "MainViewButton.h"

@implementation MainViewButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
  MainViewButton *button = [super buttonWithType:buttonType];
  [button customizeButton];
  return button;
}

- (void)customizeButton {
  
  CGRect currentFrame = self.frame;
  currentFrame.size = CGSizeMake(300.0, 35.0);
  self.frame = currentFrame;
  
  self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  self.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
  self.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17];
  [self setTintColor:[UIColor darkGrayColor]];
  self.backgroundColor = [UIColor whiteColor];
  self.layer.cornerRadius = 5.0;
  self.clipsToBounds = true;
  
}

@end
