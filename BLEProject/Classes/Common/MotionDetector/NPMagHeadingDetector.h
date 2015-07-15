//
//  NPMagHeadingDetector.h
//  BLEProject
//
//  Created by innerpeacer on 15/4/17.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@class NPMagHeadingDetector;

@protocol NPMagHeadingDetectorDelegate <NSObject>

- (void)headingDetector:(NPMagHeadingDetector *)headingDetector onMagHeadingChanged:(double)newHeading;

@end

@interface NPMagHeadingDetector : NSObject
{
    double _lastDeviceHeading;
    double _sensitivity;
}

@property (nonatomic, weak) id<NPMagHeadingDetectorDelegate> delegate;
@property (assign) double sensitivity;

+ (NPMagHeadingDetector *)newDefaultMagHeadingDetector;

- (id)initWithSensitivity:(double)s;
- (void)pushSensorValue:(CMCalibratedMagneticField)magneticField AtInterval:(CFTimeInterval) timeStamp;

@end
