//
//  ParseAPI.h
//  TownKitchen
//
//  Created by Miles Spielberg on 3/5/15.
//  Copyright (c) 2015 The Town Kitchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse.h>
#import "Order.h"

@interface ParseAPI : NSObject

+ (ParseAPI *)getInstance;

- (NSArray *)dayInventories;
- (NSArray *)ordersForUser:(User *)user;
- (PFGeoPoint *)locationForOrder:(Order *)order;
- (NSString *)imageURLForMenuOption:(NSString *)menuOption;

- (void)createOrder:(Order *)order;
- (void)addReviewForOrder:(Order *)order starCount:(NSNumber *)stars comment:(NSString *)comment;
- (void)setDeliveryLocationForOrder:(Order *)order location:(PFGeoPoint *)location;

@end
