//
//  TYBeaconPool.m
//  BLEProject
//
//  Created by innerpeacer on 15/2/2.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYBeaconPool.h"
#import "TYBeaconKey.h"
#import <CoreLocation/CoreLocation.h>
#define DEFAULT_VALID_PERIOD 3

@interface TYBeaconPoolEntity : NSObject

//@property (nonatomic, strong) NSNumber *major;
//@property (nonatomic, strong) NSNumber *minor;
//
//@property (nonatomic, assign) double accuracy;
//@property (nonatomic, assign) int rssi;

@property (nonatomic, strong) CLBeacon *beacon;

@property (nonatomic, assign) double timeInterval;

@end

@implementation TYBeaconPoolEntity

@end

@interface TYBeaconPool()
{
    NSMutableDictionary *beaconDict;
}

@end

@implementation TYBeaconPool

- (id)init
{
    return [self initWithValidTime:DEFAULT_VALID_PERIOD];
}

- (id)initWithValidTime:(double)time
{
    self = [super init];
    if (self) {
        _validityPeriod = time;
        beaconDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)pushBeacons:(NSArray *)beacons
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    for (CLBeacon *beacon in beacons) {
        NSNumber *bKey = [TYBeaconKey beaconKeyForCLBeacon:beacon];
        
        if ([beaconDict.allKeys containsObject:bKey]) {
            TYBeaconPoolEntity *entity = beaconDict[bKey];
            entity.timeInterval = now;
            entity.beacon = beacon;
        } else {
            TYBeaconPoolEntity *entity = [[TYBeaconPoolEntity alloc] init];
            entity.timeInterval= now;
            entity.beacon = beacon;
            
            [beaconDict setObject:entity forKey:bKey];
        }
    }
    
    NSMutableArray *toRemove = [NSMutableArray array];
    for (NSNumber *key in beaconDict.allKeys) {
        TYBeaconPoolEntity *entity = beaconDict[key];
        if(ABS(now - entity.timeInterval) > _validityPeriod) {
            [toRemove addObject:key];
        }
    }
    
    [beaconDict removeObjectsForKeys:toRemove];
}

- (NSArray *)getScannedBeaconsInPool
{
    NSMutableArray *array = [NSMutableArray array];
    for (TYBeaconPoolEntity *entity in beaconDict.allValues) {
        [array addObject:entity.beacon];
    }
    return array;
}

@end
