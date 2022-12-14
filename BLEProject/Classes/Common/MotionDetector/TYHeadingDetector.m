//
//  TYHeadingDetector.m
//  BLEProject
//
//  Created by innerpeacer on 15/1/30.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYHeadingDetector.h"

#define DEFAULT_SENSITIVITY 5.0

@implementation TYHeadingDetector

+ (TYHeadingDetector *)newDefaultHeadingDetector
{
    return [[TYHeadingDetector alloc] initWithSensitivity:DEFAULT_SENSITIVITY];
}

- (id)init
{
    return [self initWithSensitivity:DEFAULT_SENSITIVITY];
}

- (id)initWithSensitivity:(double)s
{
    self = [super init];
    if (self) {
        _sensitivity = s;
        _lastDeviceHeading = 0;
    }
    return self;
}

// =======================
// CMAtitude
//
// Head West = 0;
// Head North = -90
// Head South = 90
// Head East = 180 || -180

// =======================
// Map Angle
//
// North = 0 = -90 + 90;
// East = 90 = 180 - 90;
// South = 180 = 90 + 90;
// West = 270 = 0 - 90


- (void)pushSensorValue:(CMAttitude *)attitude AtInterval:(CFTimeInterval)timeStamp
{
    double attitudeAngle = attitude.yaw * 180 / PI;
    double angle = 270 - attitudeAngle;
    if (angle >= 360) {
        angle -= 360;
    }
    
    if (ABS(angle - _lastDeviceHeading) >= _sensitivity) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(headingDetector:onHeadingChanged:)]) {
//            BRTLog(@"=================== %f %f ", attitudeAngle, angle);
            [self.delegate headingDetector:self onHeadingChanged:angle];
        }
        _lastDeviceHeading = angle;
    }
}

@end
