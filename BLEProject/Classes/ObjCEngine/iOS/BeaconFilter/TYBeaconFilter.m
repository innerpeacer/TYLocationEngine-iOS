//
//  BeaconFilter.m
//  BLEProject
//
//  Created by innerpeacer on 15/1/30.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYBeaconFilter.h"
#import <CoreLocation/CoreLocation.h>
#import "TYPublicBeacon.h"
#import "BLELocationEngineConstants.h"

@interface TYEmptyFilter : TYBeaconFilter

- (id)init;

@end

@interface TYRssiFilter : TYBeaconFilter

- (id)init;

@end

@interface TYAccuracyFilter : TYBeaconFilter

- (id)init;

@end

@interface TYRangeFilter : TYBeaconFilter

- (id)init;

@end

@implementation TYBeaconFilter

+ (TYBeaconFilter *)beaconFilterWithType:(TYBeaconFilterType)type
{
    TYBeaconFilter *filter;
    switch (type) {
        case EMPTY:
            filter = [[TYEmptyFilter alloc] init];
            break;
            
        case RSSI:
            filter = [[TYRssiFilter alloc] init];
            break;
            
        case ACCURACY:
            filter = [[TYAccuracyFilter alloc] init];
            break;
            
        case RANGE:
            filter = [[TYRangeFilter alloc] init];
            break;
            
        default:
            filter = [[TYEmptyFilter alloc] init];
            break;
    }
    return filter;
}

- (NSArray *)filterBeaconFrom:(NSArray *)beaconArray withBeaconDict:(NSDictionary *)dict
{
    return beaconArray;
}

@end



@implementation TYEmptyFilter

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSArray *)filterBeaconFrom:(NSArray *)beaconArray withBeaconDict:(NSDictionary *)dict
{
    return beaconArray;
}

@end

@implementation TYRssiFilter

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSArray *)filterBeaconFrom:(NSArray *)beaconArray withBeaconDict:(NSDictionary *)dict
{
    NSArray *array = [NSArray array];
    
    array = [beaconArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CLBeacon *b1 = (CLBeacon *)obj1;
        CLBeacon *b2 = (CLBeacon *)obj2;
        
        NSNumber *l1 = [NSNumber numberWithDouble:b1.rssi];
        NSNumber *l2 = [NSNumber numberWithDouble:b2.rssi];
        return ![l1 compare:l2];
    }];

    return array;
}

@end

@implementation TYAccuracyFilter

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSArray *)filterBeaconFrom:(NSArray *)beaconArray withBeaconDict:(NSDictionary *)dict
{
    NSArray *array = [NSArray array];
    
    array = [beaconArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CLBeacon *b1 = (CLBeacon *)obj1;
        CLBeacon *b2 = (CLBeacon *)obj2;
        
        NSNumber *l1 = [NSNumber numberWithDouble:b1.accuracy];
        NSNumber *l2 = [NSNumber numberWithDouble:b2.accuracy];
        
        return [l1 compare:l2];
    }];
    
    return beaconArray;
}

@end

@implementation TYRangeFilter

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#define FILTER_RANGE 8

- (NSArray *)filterBeaconFrom:(NSArray *)beaconArray withBeaconDict:(NSDictionary *)dict
{
    int maxCount = MIN((int)beaconArray.count, 4);
    maxCount = (int)beaconArray.count;
//    int maxCount = (int)beaconArray.count;

    
    double xTotal = 0.0;
    double yTotal = 0.0;
    double weightingTotal = 0.0;
//    NSMutableArray *xArray = [NSMutableArray array];
//    NSMutableArray *yArray = [NSMutableArray array];
//    NSMutableArray *weightingArray = [NSMutableArray array];
    for (int i = 0; i < maxCount; ++i) {
        CLBeacon *beacon = beaconArray[i];
        NSNumber *key = [TYBeaconKey beaconKeyForCLBeacon:beacon];
        TYPublicBeacon *cpb = [dict objectForKey:key];
        
        double weighting = 1/ beacon.accuracy;
        weightingTotal += weighting;
        xTotal += cpb.location.x * weighting;
        yTotal += cpb.location.y * weighting;
        
//        [weightingArray addObject:@(weighting)];
//        [xArray addObject:@(cpb.location.x)];
//        [yArray addObject:@(cpb.location.y)];
    }
    
    TYLocalPoint *filterCenter = [TYLocalPoint pointWithX:xTotal/weightingTotal Y:yTotal/weightingTotal];
    NSMutableArray *resultBeaconArray = [NSMutableArray array];
    
    for (int i = 0; i < beaconArray.count; ++i) {
        CLBeacon *beacon = beaconArray[i];
        NSNumber *key = [TYBeaconKey beaconKeyForCLBeacon:beacon];
        TYPublicBeacon *cpb = [dict objectForKey:key];
        
        if ([filterCenter distanceWith:cpb.location] < FILTER_RANGE) {
            [resultBeaconArray addObject:beacon];
        }
    }
    
    return [NSArray arrayWithArray:resultBeaconArray];
}

@end