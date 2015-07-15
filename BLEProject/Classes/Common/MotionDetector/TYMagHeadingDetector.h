//
//  TYMagHeadingDetector.h
//  BLEProject
//
//  Created by innerpeacer on 15/4/17.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@class TYMagHeadingDetector;

@protocol TYMagHeadingDetectorDelegate <NSObject>

- (void)headingDetector:(TYMagHeadingDetector *)headingDetector onMagHeadingChanged:(double)newHeading;

@end

@interface TYMagHeadingDetector : NSObject
{
    double _lastDeviceHeading;
    double _sensitivity;
}

@property (nonatomic, weak) id<TYMagHeadingDetectorDelegate> delegate;
@property (assign) double sensitivity;

+ (TYMagHeadingDetector *)newDefaultMagHeadingDetector;

- (id)initWithSensitivity:(double)s;
- (void)pushSensorValue:(CMCalibratedMagneticField)magneticField AtInterval:(CFTimeInterval) timeStamp;

@end
