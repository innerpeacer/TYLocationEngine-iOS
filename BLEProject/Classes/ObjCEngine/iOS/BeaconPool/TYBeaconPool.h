//
//  TYBeaconPool.h
//  BLEProject
//
//  Created by innerpeacer on 15/2/2.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYBeaconPool : NSObject

@property (nonatomic, assign) double validityPeriod;

- (id)initWithValidTime:(double)time;
- (void)pushBeacons:(NSArray *)beacons;
- (NSArray *)getScannedBeaconsInPool;

@end
