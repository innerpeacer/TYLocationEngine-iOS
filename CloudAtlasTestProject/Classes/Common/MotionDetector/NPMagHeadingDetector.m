//
//  NPMagHeadingDetector.m
//  CloudAtlasTestProject
//
//  Created by innerpeacer on 15/4/17.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "NPMagHeadingDetector.h"
#import "NPVector2.h"

#define DEFAULT_SENSITIVITY 5.0

@implementation NPMagHeadingDetector

+ (NPMagHeadingDetector *)newDefaultMagHeadingDetector
{
    return [[NPMagHeadingDetector alloc] initWithSensitivity:DEFAULT_SENSITIVITY];
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

- (void)pushSensorValue:(CMCalibratedMagneticField)magneticField AtInterval:(CFTimeInterval)timeStamp
{
//    NSLog(@"x: %f", magneticField.field.x);
//    NSLog(@"y: %f", magneticField.field.y);
//    NSLog(@"z: %f", magneticField.field.z);
    
    double x = magneticField.field.x;
    double y = magneticField.field.y;
    
    NPVector2 *v = [[NPVector2 alloc] init];
    v.x = x;
    v.y = y;
    
    double angle = -[v getAngle];
    
    if (ABS(angle - _lastDeviceHeading) >= _sensitivity) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(headingDetector:onMagHeadingChanged:)]) {
            [self.delegate headingDetector:self onMagHeadingChanged:angle];
        }
        _lastDeviceHeading = angle;
    }
    
//    double attitudeAngle = attitude.yaw * 180 / PI;
//    
//    double angle = 270 - attitudeAngle;
//    if (angle >= 360) {
//        angle -= 360;
//    }
//    
//    if (ABS(angle - _lastDeviceHeading) >= _sensitivity) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(headingDetector:onHeadingChanged:)]) {
//            [self.delegate headingDetector:self onHeadingChanged:angle];
//        }
//        _lastDeviceHeading = angle;
//    }
    
}

@end
