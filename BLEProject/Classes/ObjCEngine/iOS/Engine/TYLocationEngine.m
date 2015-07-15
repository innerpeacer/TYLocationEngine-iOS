//
//  CALocationEngine.m
//  BLEProject
//
//  Created by innerpeacer on 15/1/29.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYLocationEngine.h"
#import "TYMovingAverage.h"
#import "TYAlgorithmFactory.h"
#import "TYGeometryCalculator.h"

#define DEFAULT_STEP 1
#define DEFAULT_STEP_LENGTH 0.5
#define MOVING_AVERAGE_WINDOW 5

@interface TYLocationEngine()
{
    TYLocationAlgorithm *algorithm;
    AlgorithmType type;
    
    NSDictionary *publicBeaconDict;
    
    TYLocalPoint *currentDisplayLocation;
    TYLocalPoint *currentAnchorLocation;
    TYLocalPoint *currentDirectLocation;
    
    TYMovingAverage *xMovingAverage;
    TYMovingAverage *yMovingAverage;
    
    int stepCount;
}

@end


@implementation TYLocationEngine

+ (TYLocationEngine *)locationEngineWithBeacons:(NSDictionary *)dict
{
    return [[TYLocationEngine alloc] initWithBeacons:dict Type:HybridSingle];
}

+ (TYLocationEngine *)locationEngineWithBeacons:(NSDictionary *)dict Type:(AlgorithmType)aType
{
    return [[TYLocationEngine alloc] initWithBeacons:dict Type:aType];
}


- (id)initWithBeacons:(NSDictionary *)dict Type:(AlgorithmType)aType
{
    self = [super init];
    if (self) {
        xMovingAverage = [[TYMovingAverage alloc] initWithWindow:MOVING_AVERAGE_WINDOW];
        yMovingAverage = [[TYMovingAverage alloc] initWithWindow:MOVING_AVERAGE_WINDOW];
        
        publicBeaconDict = dict;
        algorithm = [TYAlgorithmFactory locationAlgorithmWithBeaconDictionary:publicBeaconDict Type:aType];
        type = aType;
        stepCount = DEFAULT_STEP;
    }
    return self;
}

- (void)addStepEvent:(TYStepEvent *)event
{
    stepCount++;
}

- (void)processBeacons:(NSArray *)scannedBeacons
{
    algorithm.nearestBeacons = scannedBeacons;
    
    TYLocalPoint *newLocation = [self calculateLocation];
    currentDirectLocation = newLocation;
    
    if (newLocation == nil) {
        return;
    }
    
    if (currentAnchorLocation == nil) {
        currentAnchorLocation = newLocation;
        currentDisplayLocation = newLocation;
        xMovingAverage = [[TYMovingAverage alloc] initWithWindow:MOVING_AVERAGE_WINDOW];
        yMovingAverage = [[TYMovingAverage alloc] initWithWindow:MOVING_AVERAGE_WINDOW];
        [xMovingAverage push:@(newLocation.x)];
        [yMovingAverage push:@(newLocation.y)];
    } else {
        if (stepCount == DEFAULT_STEP) {
            [xMovingAverage push:@(newLocation.x)];
            [yMovingAverage push:@(newLocation.y)];
            currentDisplayLocation = [TYLocalPoint pointWithX:xMovingAverage.average Y:yMovingAverage.average Floor:newLocation.floor];
        } else {
            double length = stepCount * DEFAULT_STEP_LENGTH;
            double distance = [TYLocalPoint distanceBetween:newLocation and:currentAnchorLocation];
            if (distance < length) {
                currentAnchorLocation = newLocation;
                currentDisplayLocation = newLocation;
                stepCount = DEFAULT_STEP;
                xMovingAverage = [[TYMovingAverage alloc] initWithWindow:MOVING_AVERAGE_WINDOW];
                yMovingAverage = [[TYMovingAverage alloc] initWithWindow:MOVING_AVERAGE_WINDOW];
            } else {
                currentDisplayLocation = [TYGeometryCalculator scalePointWithCenter:currentAnchorLocation scaled:newLocation ForLength:length];
            }
        }
    }
}

- (TYLocalPoint *)calculateLocation
{
    return [algorithm calculationLocation];
}

- (TYLocalPoint *)getLocation
{
    return currentDisplayLocation;
}

- (TYLocalPoint *)getDirectioLocation
{
    return currentDirectLocation;
}

@end
