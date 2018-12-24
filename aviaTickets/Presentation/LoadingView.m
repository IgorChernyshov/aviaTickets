//
//  LoadingView.m
//  aviaTickets
//
//  Created by Igor Chernyshov on 22/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView {
  BOOL isActive;
}

+ (instancetype)sharedInstance
{
  static LoadingView *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[LoadingView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [instance setup];
  });
  return instance;
}

- (void)setup
{
  UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
  backgroundImageView.image = [UIImage imageNamed:@"cloudsBackground"];
  backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
  backgroundImageView.clipsToBounds = YES;
  [self addSubview:backgroundImageView];
  
  UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
  UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
  blurEffectView.frame = self.bounds;
  [self addSubview:blurEffectView];
  
  [self createPlanes];
}

- (void)createPlanes
{
  for (int i = 1; i < 6; i++) {
    int randomHeight = arc4random_uniform(self.bounds.size.height - 100) + 50;
    UIImageView *plane = [[UIImageView alloc] initWithFrame:CGRectMake(-50.0, randomHeight, 50.0, 50.0)];
    plane.tag = i;
    plane.image = [UIImage imageNamed:@"plane"];
    [self addSubview:plane];
  }
}

- (void)startAnimating:(NSInteger)planeID
{
  if (!isActive) return;
  if (planeID >= 6) planeID = 1;
  
  UIImageView *plane = [self viewWithTag:planeID];
  if (plane) {
    [UIView animateWithDuration:1.5 animations:^{
      plane.frame = CGRectMake(self.bounds.size.width, plane.frame.origin.y, 50.0, 50.0);
    } completion:^(BOOL finished) {
      plane.frame = CGRectMake(-50.0, plane.frame.origin.y, 50.0, 50.0);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      [self startAnimating:planeID+1];
    });
  }
}

- (void)show:(void (^)(void))completion
{
  self.alpha = 0.0;
  isActive = YES;
  [self startAnimating:1];
  [[[UIApplication sharedApplication] keyWindow] addSubview:self];
  [UIView animateWithDuration:1.0 animations:^{
    self.alpha = 1.0;
  } completion:^(BOOL finished) {
    completion();
  }];
}

- (void)dismiss:(void (^)(void))completion
{
  [UIView animateWithDuration:0.5 animations:^{
    self.alpha = 0.0;
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
    self->isActive = NO;
    if (completion) {
      completion();
    }
  }];
}

@end
