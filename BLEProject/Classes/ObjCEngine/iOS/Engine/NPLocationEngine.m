//
//  CALocationEngine.m
//  BLEProject
//
//  Created by innerpeacer on 15/1/29.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "NPLocationEngine.h"
#import "NPMovingAverage.h"
#import "NPAlgorithmFactory.h"
#import "NPGeometryCalculator.h"

#define DEFAULT_STEP 1
#define DEFAULT_STEP_LENGTH 0.5
#define MOVING_AVERAGE_WINDOW 5

@interface NPLocationEngine()
{
    NPLocationAlgorithm *algorithm;
    AlgorithmType type;
    
    NSDictionary *publicBeaconDict;
    
    TYLocalPoint *currentDisplayLocation;
    TYLocalPoint *currentAnchorLocation;
    TYLocalPoint *currentDirectLocation;
    
    NPMovingAverage *xMovingAverage;
    NPMovingAverage *yMovingAverage;
    
    int stepCount;
}

@end


@implementation NPLocationEngine

+ (NPLocationEngine *)locationEngineWithBeacons:(NSDictionary *)dict
{
    return [[NPLocationEngine alloc] initWithBeacons:dict Type:HybridSingle];
}

+ (NPLocationEngine *)locationEngineWithBeacons:(NSDictionary *)dict Type:(AlgorithmType)aType
{
    return [[NPLocationEngine alloc] initWithBeacons:dict Type:aType];
}


- (id)initWithBeacons:(NSDictionary *)dict Type:(AlgorithmType)aType
{
    self = [super init];
    if (self) {
        xMovingAverage = [[NPMovingAverage alloc] initWithWindow:MOVING_AVERAGE_WINDOW];
        yMovingAverage = [[NPMovingAverage alloc] initWithWindow:MOVING_AVERAGE_WINDOW];
        
        publicBeaconDict = dict;
        algorithm = [NPAlgorithmFactory locationAlgorithmWithBeaconDictionary:publicBeaconDict Type:aType];
        type = aType;
        stepCount = DEFAULT_STEP;
    }
    return self;
}

- (void)addStepEvent:(NPStepEvent *)event
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
        xMovingAverage = [[NPMovingAverage alloc] initWithWindow:MOVING_AVERAGE_WINDOW];
        yMovingAverage = [[NPMovingAverage alloc] initWithWindow:MOVING_AVERAGE_WINDOW];
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
                xMovingAverage = [[NPMovingAverage alloc] initWithWindow:MOVING_AVERAGE_WINDOW];
                yMovingAverage = [[NPMovingAverage alloc] initWithWindow:MOVING_AVERAGE_WINDOW];
            } else {
                currentDisplayLocation = [NPGeometryCalculator scalePointWithCenter:currentAnchorLocation scaled:newLocation ForLength:length];
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
