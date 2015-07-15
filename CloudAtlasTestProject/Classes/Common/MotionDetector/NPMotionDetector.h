//
//  CAMotionDetector.h
//  CloudAtlasTestProject
//
//  Created by innerpeacer on 15/1/30.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPStepEvent.h"

@class NPMotionDetector;

@protocol NPMotionDetectorDelegate <NSObject>

@optional
- (void)motionDetector:(NPMotionDetector *)detector onHeadingChanged:(double)heading;

- (void)motionDetector:(NPMotionDetector *)detector onStepEvent:(NPStepEvent *)stepEvent;

@end


@interface NPMotionDetector : NSObject

@property (readonly) BOOL isStepDetectorActive;
@property (readonly) BOOL isHeadingDetectorActive;

@property (nonatomic, weak) id<NPMotionDetectorDelegate> delegate;

- (void)startStepDetector;
- (void)stopStepDetector;
- (void)startHeadingDetector;
- (void)stopHeadingDetector;

- (void)stopAllDetectors;

@end
