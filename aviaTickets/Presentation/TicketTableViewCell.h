//
//  TicketTableViewCell.h
//  aviaTickets
//
//  Created by Igor Chernyshov on 08/12/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
#import "Ticket.h"

@interface TicketTableViewCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;

@end
