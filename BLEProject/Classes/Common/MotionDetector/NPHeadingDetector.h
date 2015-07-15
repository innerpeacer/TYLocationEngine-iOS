//
//  CAHeadingDetector.h
//  CloudAtlasTestProject
//
//  Created by innerpeacer on 15/1/30.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NephogramConstants.h"
#import <CoreMotion/CoreMotion.h>

@class NPHeadingDetector;

@protocol NPHeadingDetectorDelegate <NSObject>

- (void)headingDetector:(NPHeadingDetector *)headingDetector onHeadingChanged:(double)heading;

@end


@interface NPHeadingDetector : NSObject
{
    double _lastDeviceHeading;
    double _sensitivity;
}

@property (nonatomic, weak) id<NPHeadingDetectorDelegate> delegate;
@property (assign) double sensitivity;

+ (NPHeadingDetector *)newDefaultHeadingDetector;

- (id)initWithSensitivity:(double)s;
- (void)pushSensorValue:(CMAttitude *)attitude AtInterval:(CFTimeInterval) timeStamp;

@end

