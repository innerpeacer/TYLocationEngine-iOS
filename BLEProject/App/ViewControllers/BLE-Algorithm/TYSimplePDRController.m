
//
//  TYPDRController.m
//  BLEProject
//
//  Created by innerpeacer on 2017/4/20.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYSimplePDRController.h"

#define DEFAULT_STRIDE_LENGTH 0.5

@interface TYSimplePDRController()
{
    double initAngle;
    
    double currentHeading;
    double strideLength;
    
    BOOL headingReady;
}

@end

@implementation TYSimplePDRController

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
//    BRTLog(@"Set: %@", _currentLocation);
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
