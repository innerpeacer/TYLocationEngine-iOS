//
//  CAStepDetector.h
//  CloudAtlasTestProject
//
//  Created by innerpeacer on 15/1/30.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPStepEvent.h"
#import <CoreMotion/CoreMotion.h>

@class NPStepDetector;

@protocol NPStepDetectorDelegate <NSObject>

- (void)stepDetector:(NPStepDetector *)stepDetector onStepEvent:(NPStepEvent *)step;

@end

@interface NPStepDetector : NSObject

@property (nonatomic, weak) id<NPStepDetectorDelegate> delegate;

+ (NPStepDetector *)newDefaultStepDetector;

-(void)pushSensorValue:(CMAcceleration)accer AtInterval:(CFTimeInterval) timeStamp;
- (void)reset;

@end
