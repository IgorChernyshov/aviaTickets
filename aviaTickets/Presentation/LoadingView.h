//
//  LoadingView.h
//  aviaTickets
//
//  Created by Igor Chernyshov on 22/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+ (instancetype)sharedInstance;

- (void)show:(void (^)(void))completion;
- (void)dismiss:(void (^)(void))completion;

@end
