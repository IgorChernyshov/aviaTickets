//
//  ViewController.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 01/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Set view's background color
  UIColor *lightBlueColor = [UIColor colorWithRed:97.0/255.0
                                            green:215.0/255.0
                                             blue:255.0/255.0
                                            alpha:1];
  self.view.backgroundColor = lightBlueColor;
  
  // Create a label
  UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  welcomeLabel.font = [UIFont fontWithName:@"Avenir Next" size:17];
  welcomeLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
  welcomeLabel.text = @"Welcome to Avia Tickets!";
  welcomeLabel.textColor = UIColor.whiteColor;
  [welcomeLabel sizeToFit];
  CGRect temporaryRect = welcomeLabel.frame;
  temporaryRect.origin = CGPointMake(CGRectGetWidth(self.view.frame) / 2 - CGRectGetWidth(temporaryRect) / 2, CGRectGetHeight(self.view.frame) / 2 - CGRectGetHeight(temporaryRect) / 2);
  welcomeLabel.frame = temporaryRect;
  [self.view addSubview:welcomeLabel];
}


@end
