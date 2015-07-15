//
//  BeaconFilter.h
//  BLEProject
//
//  Created by innerpeacer on 15/1/30.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    EMPTY, RSSI, ACCURACY, RANGE
} CABeaconFilterType;

@interface TYBeaconFilter : NSObject

- (NSArray *)filterBeaconFrom:(NSArray *)beaconArray withBeaconDict:(NSDictionary *)dict;

+ (TYBeaconFilter *)beaconFilterWithType:(CABeaconFilterType)type;

@end
