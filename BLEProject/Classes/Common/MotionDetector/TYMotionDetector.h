//
//  TYMotionDetector.h
//  BLEProject
//
//  Created by innerpeacer on 15/1/30.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYStepEvent.h"

@class TYMotionDetector;

@protocol TYMotionDetectorDelegate <NSObject>

@optional
- (void)motionDetector:(TYMotionDetector *)detector onHeadingChanged:(double)heading;

- (void)motionDetector:(TYMotionDetector *)detector onStepEvent:(TYStepEvent *)stepEvent;

@end


@interface TYMotionDetector : NSObject

@property (readonly) BOOL isStepDetectorActive;
@property (readonly) BOOL isHeadingDetectorActive;

@property (nonatomic, weak) id<TYMotionDetectorDelegate> delegate;

- (void)startStepDetector;
- (void)stopStepDetector;
- (void)startHeadingDetector;
- (void)stopHeadingDetector;

- (void)stopAllDetectors;

@end
