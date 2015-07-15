//
//  CAWeightingAlgorithm.m
//  BLEProject
//
//  Created by innerpeacer on 15/1/29.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "NPWeightingAlgorithm.h"
#import <CoreLocation/CoreLocation.h>
#import "NPPublicBeacon.h"
#import "NephogramConstants.h"

@interface NPLinearWeightingAlgorithm : NPWeightingAlgorithm

@end

@interface NPQuadraticWeightingAlgorithm : NPWeightingAlgorithm

@end

@implementation NPWeightingAlgorithm

- (id)initWithBeaconDictionary:(NSDictionary *)dict
{
    self = [super initWithBeaconDictionary:dict];
    if (self) {
        
    }
    return self;
}

+ (NPWeightingAlgorithm *)algorithmWithBeaconDictionary:(NSDictionary *)dict Type:(AlgorithmType)type
{
    switch (type) {
        case LinearWeighting:
            return [[NPLinearWeightingAlgorithm alloc] initWithBeaconDictionary:dict];
            break;
            
        case QuadraticWeighting:
            return [[NPQuadraticWeightingAlgorithm alloc] initWithBeaconDictionary:dict];
            break;
            
        default:
            return nil;
            break;
    }
}

@end

@implementation NPLinearWeightingAlgorithm

- (TYLocalPoint *)calculationLocation
{
    NSMutableArray *weightingArray = [NSMutableArray array];
    NSMutableArray *pointArray = [NSMutableArray array];
    double totalWeighting = 0.0;
    double totalWeightingX = 0.0;
    double totalWeightingY = 0.0;

    for (int i = 0; i < self.nearestBeacons.count; ++i) {
        CLBeacon *b = self.nearestBeacons[i];
        NSNumber *bkey = [NPBeaconKey beaconKeyForCLBeacon:b];;
        NPPublicBeacon *pb = [self.beaconDictionary objectForKey:bkey];
        
        double weighting = 1.0/b.accuracy;
        [weightingArray addObject:@(weighting)];
        totalWeighting += weighting;
        
        [pointArray addObject:pb.location];
    }
    
    for (int i = 0; i < weightingArray.count; ++i) {
        TYLocalPoint *point = [pointArray objectAtIndex:i];
        
        totalWeightingX += point.x * [weightingArray[i] doubleValue];
        totalWeightingY += point.y * [weightingArray[i] doubleValue];
    }
    
    return [TYLocalPoint pointWithX:totalWeightingX/totalWeighting Y:totalWeightingY/totalWeighting Floor:4];
}

@end

@implementation NPQuadraticWeightingAlgorithm

- (TYLocalPoint *)calculationLocation
{
    NSMutableArray *weightingArray = [NSMutableArray array];
    NSMutableArray *pointArray = [NSMutableArray array];
    double totalWeighting = 0.0;
    double totalWeightingX = 0.0;
    double totalWeightingY = 0.0;
    
    for (int i = 0; i < self.nearestBeacons.count; ++i) {
        CLBeacon *b = self.nearestBeacons[i];
        NSNumber *bkey = [NPBeaconKey beaconKeyForCLBeacon:b];;
        NPPublicBeacon *pb = [self.beaconDictionary objectForKey:bkey];
        
        double weighting = 1.0/pow(b.accuracy, 2);
        [weightingArray addObject:@(weighting)];
        totalWeighting += weighting;
        
        [pointArray addObject:pb.location];
    }
    
    for (int i = 0; i < weightingArray.count; ++i) {
        TYLocalPoint *point = [pointArray objectAtIndex:i];
        
        totalWeightingX += point.x * [weightingArray[i] doubleValue];
        totalWeightingY += point.y * [weightingArray[i] doubleValue];
    }
    
    return [TYLocalPoint pointWithX:totalWeightingX/totalWeighting Y:totalWeightingY/totalWeighting Floor:4];
}


@end
