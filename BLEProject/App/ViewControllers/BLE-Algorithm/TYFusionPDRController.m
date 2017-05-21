//
//  TYFusionPDRController.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/15.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYFusionPDRController.h"

#define DEFAULT_STRIDE_SCALE 0.2

#define DEFAULT_STRIDE_LENGTH 0.5

#define DEFAULT_ACCUMULATE_STEPS 5

#define DEFAULT_TOLERANCE_DISTANCE 5

@interface TYFusionPDRController()
{
    double initAngle;
    
    double currentHeading;
    
    double strideLength;
    
    BOOL headingReady;
    
    int cumulatedSteps;
}

@end

@implementation TYFusionPDRController
@synthesize currentHeading = currentHeading;

- (id)initWithAngle:(double)angle
{
    self = [super init];
    if (self) {
        initAngle = 0;
        headingReady = NO;
        strideLength = DEFAULT_STRIDE_LENGTH;
        
        _currentFanRange = [[TYFanRange alloc] init];
        _currentRangeStatus = IP_Unknown;
        
        _stepReseting = NO;
    }
    return self;
}

- (void)setStartLocation:(TYLocalPoint *)start
{
    _currentLocation = start;
    _currentFanRange.center = start;
    BRTLog(@"Set: %@", _currentLocation);

    cumulatedSteps = 1;
    _stepReseting = NO;
}

- (void)updateRawSignalEvent:(TYRawSignalEvent *)signal
{
    TYLocalPoint *location = [signal.immediateLocation toLocalPoint];
    double distance = [_currentLocation distanceWith:location];
    if (distance > DEFAULT_TOLERANCE_DISTANCE) {
        _currentLocation = location;
        _currentFanRange.center = location;
        _stepReseting = YES;
    } else {
        _stepReseting = NO;
    }
    
//    if ([_currentFanRange containPoint:[signal.immediateLocation toLocalPoint]]) {
//        //        BRTLog(@"Contain");
//        //        _currentLocation = location;
//        //        _currentFanRange.center = location;
//        strideLength = DEFAULT_STRIDE_LENGTH;
//        cumulatedSteps = 1;
//    } else {
////        BRTLog(@"Not Contain");
//        strideLength = DEFAULT_STRIDE_LENGTH * (1 - DEFAULT_STRIDE_SCALE);
//        cumulatedSteps++;
//        
//        if (cumulatedSteps >= DEFAULT_ACCUMULATE_STEPS) {
//            _currentLocation = location;
//            _currentFanRange.center = location;
//            cumulatedSteps = 1;
//        }
//    }
//    
    switch ([_currentFanRange getStatus:[signal.immediateLocation toLocalPoint]]) {
        case IP_Contain:
            BRTLog(@"Contain");
            _currentRangeStatus = IP_Contain;
            strideLength = DEFAULT_STRIDE_LENGTH;
            break;
            
        case IP_Forward:
            BRTLog(@"Forward");
            _currentRangeStatus = IP_Forward;
            strideLength = DEFAULT_STRIDE_LENGTH * 0.5;
            break;
            
        case IP_Backward:
            BRTLog(@"Backward");
            _currentRangeStatus = IP_Backward;
            strideLength = DEFAULT_STRIDE_LENGTH * 1.5;
            break;
            
        default:
            BRTLog(@"Unknown");
            _currentRangeStatus = IP_Unknown;
            break;
    }
}

- (void)addStepEvent
{
    if (_currentLocation == nil && !headingReady) {
        return;
    }
    
    double headingInRad = PI * currentHeading / 180.0;
    _currentLocation = [TYLocalPoint pointWithX:_currentLocation.x + strideLength * sin(headingInRad) Y:_currentLocation.y + strideLength * cos(headingInRad)];
    _currentFanRange.center = _currentLocation;
}

- (void)updateHeading:(double)newHeading
{
    headingReady = YES;
    currentHeading = newHeading;
    _currentFanRange.heading = @(currentHeading);
}

- (void)reset
{
    _currentLocation = nil;
    headingReady = NO;
}

@end
