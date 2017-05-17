//
//  TYFusionPDRController.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/15.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYFusionPDRController.h"

#define DEFAULT_STRIDE_LENGTH 0.5
#define DEFAULT_TOLERANCE_DISTANCE 3

@interface TYFusionPDRController()
{
    double initAngle;
    
    double currentHeading;
    double strideLength;
    
    BOOL headingReady;
}

@end

@implementation TYFusionPDRController

- (id)initWithAngle:(double)angle
{
    self = [super init];
    if (self) {
        initAngle = 0;
        headingReady = NO;
        strideLength = DEFAULT_STRIDE_LENGTH;
    }
    return self;
}

- (void)setStartLocation:(TYLocalPoint *)start
{
    _currentLocation = start;
    BRTLog(@"Set: %@", _currentLocation);
}

- (void)updateRawSignalEvent:(TYRawSignalEvent *)signal
{
    TYLocalPoint *location = [signal.immediateLocation toLocalPoint];
    double distance = [_currentLocation distanceWith:location];
//    BRTLog(@"Distance: %f", distance);
    if (distance > DEFAULT_TOLERANCE_DISTANCE) {
        _currentLocation = location;
    }
}

- (void)addStepEvent
{
    if (_currentLocation == nil && !headingReady) {
        return;
    }
    
    double headingInRad = PI * currentHeading / 180.0;
    //    headingInRad = headingInRad * -1;
    _currentLocation = [TYLocalPoint pointWithX:_currentLocation.x + strideLength * sin(headingInRad) Y:_currentLocation.y + strideLength * cos(headingInRad)];
}

- (void)updateHeading:(double)newHeading
{
    headingReady = YES;
    currentHeading = newHeading;
}

- (void)reset
{
    _currentLocation = nil;
    headingReady = NO;
}

@end
