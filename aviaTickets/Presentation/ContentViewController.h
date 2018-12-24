//
//  ContentViewController.h
//  aviaTickets
//
//  Created by Igor Chernyshov on 23/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentViewController : UIViewController

@property (nonatomic, strong) NSString *contentText;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) int index;

@end

NS_ASSUME_NONNULL_END
