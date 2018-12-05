//
//  SelectPlaceViewController.h
//  aviaTickets
//
//  Created by Igor Chernyshov on 04/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

typedef enum PlaceType {
  PlaceTypeArrival,
  PlaceTypeDeparture
} PlaceType;

@protocol SelectPlaceViewControllerDelegate <NSObject>
- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;
@end

@interface SelectPlaceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<SelectPlaceViewControllerDelegate>delegate;
- (instancetype)initWithType:(PlaceType)type;

@end
