//
//  ViewController.h
//  aviaTickets
//
//  Created by Igor Chernyshov on 01/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct SearchRequest {
  __unsafe_unretained NSString *origin;
  __unsafe_unretained NSString *destination;
  __unsafe_unretained NSDate *departDate;
  __unsafe_unretained NSDate *returnDate;
} SearchRequest;

@interface MainViewController : UIViewController

@end

