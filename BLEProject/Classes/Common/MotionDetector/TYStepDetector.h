//
//  TYStepDetector.h
//  BLEProject
//
//  Created by innerpeacer on 15/1/30.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYStepEvent.h"
#import <CoreMotion/CoreMotion.h>

@class TYStepDetector;

@protocol TYStepDetectorDelegate <NSObject>

- (void)stepDetector:(TYStepDetector *)stepDetector onStepEvent:(TYStepEvent *)step;

@end

@interface TYStepDetector : NSObject

@property (nonatomic, weak) id<TYStepDetectorDelegate> delegate;

+ (TYStepDetector *)newDefaultStepDetector;

-(void)pushSensorValue:(CMAcceleration)accer AtInterval:(CFTimeInterval) timeStamp;
- (void)reset;

@end
