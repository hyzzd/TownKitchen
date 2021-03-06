//
//  TKOrderSummaryCell.h
//  TownKitchen
//
//  Created by Miles Spielberg on 3/8/15.
//  Copyright (c) 2015 The Town Kitchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface TKOrderSummaryCell : UITableViewCell

@property (strong, nonatomic) Order *order;
@property (nonatomic) BOOL isTrackingForDelivery;

@end
