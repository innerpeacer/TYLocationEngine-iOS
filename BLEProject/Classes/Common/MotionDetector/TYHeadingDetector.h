//
//  TYHeadingDetector.h
//  BLEProject
//
//  Created by innerpeacer on 15/1/30.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLELocationEngineConstants.h"
#import <CoreMotion/CoreMotion.h>

@class TYHeadingDetector;

@protocol TYHeadingDetectorDelegate <NSObject>

- (void)headingDetector:(TYHeadingDetector *)headingDetector onHeadingChanged:(double)heading;

@end


@interface TYHeadingDetector : NSObject
{
    double _lastDeviceHeading;
    double _sensitivity;
}

@property (nonatomic, weak) id<TYHeadingDetectorDelegate> delegate;
@property (assign) double sensitivity;

+ (TYHeadingDetector *)newDefaultHeadingDetector;

- (id)initWithSensitivity:(double)s;
- (void)pushSensorValue:(CMAttitude *)attitude AtInterval:(CFTimeInterval) timeStamp;

@end

