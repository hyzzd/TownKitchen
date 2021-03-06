//
//  DayViewCell.h
//  TownKitchen
//
//  Created by Neal Wu on 3/10/15.
//  Copyright (c) 2015 The Town Kitchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Inventory.h"

@interface DayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (readonly, nonatomic) NSString *weekday;
@property (readonly, nonatomic) NSString *monthAndDay;

- (void)setDate:(NSDate *)date andMenuOption:(MenuOption *)menuOptionObject;

@end
