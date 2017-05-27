//
//  TYFusionPDRController.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/15.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYFusionPDRController.h"


#define DEFAULT_ACCUMULATE_STEPS 5

#define DEFAULT_TOLERANCE_DISTANCE 5

@interface TYFusionPDRController()
{
    double initAngle;
    
    BOOL headingReady;
    
    int cumulatedSteps;
    
    TYStatusObject *statusObject;
}

@end

@implementation TYFusionPDRController
@synthesize statusObject = statusObject;

- (id)initWithAngle:(double)angle
{
    self = [super init];
    if (self) {
        initAngle = 0;
        headingReady = NO;
        _stepReseting = NO;
        statusObject = [[TYStatusObject alloc] init];
    }
    return self;
}

- (void)setStartLocation:(TYLocalPoint *)start
{
    _currentLocation = start;
    [statusObject updateCenter:start];

    cumulatedSteps = 1;
    _stepReseting = NO;
}

- (void)updateRawSignalEvent:(TYRawSignalEvent *)signal
{
    TYLocalPoint *location = [signal.immediateLocation toLocalPoint];
    double distance = [_currentLocation distanceWith:location];
    if (distance > DEFAULT_TOLERANCE_DISTANCE) {
        _currentLocation = location;
        [statusObject updateCenter:location];
        _stepReseting = YES;
    } else {
        _stepReseting = NO;
    }
    
//    if ([_currentFanRange containPoint:[signal.immediateLocation toLocalPoint]]) {
//        //        BRTLog(@"Contain");
//        //        _currentLocation = location;
//        //        _currentFanRange.center = location;
//        cumulatedSteps = 1;
//    } else {
////        BRTLog(@"Not Contain");
//        cumulatedSteps++;
//        if (cumulatedSteps >= DEFAULT_ACCUMULATE_STEPS) {
//            _currentLocation = location;
//            cumulatedSteps = 1;
//        }
//    }

    [statusObject updateRangeStatus:[signal.immediateLocation toLocalPoint]];
    [statusObject updateSignal:signal];
}

- (void)addStepEvent
{
    if (_currentLocation == nil && !headingReady) {
        return;
    }
    
    double headingInRad = PI * statusObject.currentHeading / 180.0;
    double strideLength = statusObject.currentStrideLength;
    _currentLocation = [TYLocalPoint pointWithX:_currentLocation.x + strideLength * sin(headingInRad) Y:_currentLocation.y + strideLength * cos(headingInRad)];
    [statusObject updateCenter:_currentLocation];
}

- (void)updateHeading:(double)newHeading
{
    headingReady = YES;
    [statusObject updateHeading:newHeading];
}

- (void)reset
{
    _currentLocation = nil;
    headingReady = NO;
}

@end
