//
//  OrderCreationTableViewCell.m
//  TownKitchen
//
//  Created by Peter Bai on 3/7/15.
//  Copyright (c) 2015 The Town Kitchen. All rights reserved.
//

#import "OrderCreationCell.h"

#import <UIImageView+AFNetworking.h>


@interface OrderCreationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *mealImage;
@property (weak, nonatomic) IBOutlet UILabel *mealDescription;
@property (weak, nonatomic) IBOutlet UILabel *orderQuantityLabel;
@property (weak, nonatomic) IBOutlet UIStepper *orderStepper;

@end

@implementation OrderCreationCell

- (void)awakeFromNib {
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.mealDescription.preferredMaxLayoutWidth = self.mealDescription.frame.size.width;
}

#pragma mark Custom Setters

- (void)setMenuOption:(MenuOption *)menuOption {
    _menuOption = menuOption;
    self.mealDescription.text = menuOption.mealDescription;
    [self.mealImage setImageWithURL:[NSURL URLWithString:menuOption.imageURL]];
}

- (void)setQuantity:(NSNumber *)quantity {
    self.orderStepper.value = [quantity doubleValue];
    self.orderQuantityLabel.text = [NSString stringWithFormat:@"%ld", [quantity integerValue]];
}

#pragma mark Private Methods

- (void)setup{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark Actions

- (IBAction)onStepperChanged:(UIStepper *)stepper {
    NSNumber *value = [NSNumber numberWithDouble:stepper.value];
    self.orderQuantityLabel.text = [NSString stringWithFormat:@"%@", value];
    [self.delegate orderCreationTableViewCell:self didUpdateQuantity:value];
}

@end
