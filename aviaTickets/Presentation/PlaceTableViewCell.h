//
//  PlaceTableViewCell.h
//  aviaTickets
//
//  Created by Igor Chernyshov on 05/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface PlaceTableViewCell : UITableViewCell

- (instancetype)initWithCity:(City *)city;
- (instancetype)initWithAirport:(Airport *)airport;

@end
