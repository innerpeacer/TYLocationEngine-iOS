//
//  CAMotionDetector.m
//  CloudAtlasTestProject
//
//  Created by innerpeacer on 15/1/30.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "NPMotionDetector.h"
#import "NPStepDetector.h"
#import "NPHeadingDetector.h"
#import "NPMagHeadingDetector.h"

#define UPDATE_FREQUENY 100.0

@interface NPMotionDetector() <NPStepDetectorDelegate, NPHeadingDetectorDelegate, NPMagHeadingDetectorDelegate>
{
    NPStepDetector *_stepDetector;
    NPHeadingDetector *_headingDetector;
//    NPMagHeadingDetector *_magHeadingDetector;

    CMMotionManager *_motionManager;
}

@end

@implementation NPMotionDetector

- (id)init
{
    self = [super init];
    if (self) {
        _isStepDetectorActive = NO;
        _isHeadingDetectorActive = NO;
        
        _motionManager = [[CMMotionManager alloc] init];
        
        _stepDetector = [NPStepDetector newDefaultStepDetector];
        _stepDetector.delegate = self;
        
        _headingDetector = [NPHeadingDetector newDefaultHeadingDetector];
        _headingDetector.delegate = self;
        
//        _magHeadingDetector = [NPMagHeadingDetector newDefaultMagHeadingDetector];
//        _magHeadingDetector.delegate = self;
        
    }
    return self;
}

- (void)startStepDetector
{
    if (_isStepDetectorActive) {
        return;
    }
    
    _isStepDetectorActive = YES;
    [self startUpdates];
}

- (void)stopStepDetector
{
    if (!_isStepDetectorActive) {
        return;
    }
    
    _isStepDetectorActive = NO;
    if (!_isStepDetectorActive && !_isHeadingDetectorActive) {
        [self stopUpdates];
    }
}

- (void)startHeadingDetector
{
    if (_isHeadingDetectorActive) {
        return;
    }
    
    _isHeadingDetectorActive = YES;
    [self startUpdates];
}

- (void)stopHeadingDetector
{
    if (!_isHeadingDetectorActive) {
        return;
    }
    
    _isHeadingDetectorActive = NO;
    if (!_isStepDetectorActive && !_isHeadingDetectorActive) {
        [self stopUpdates];
    }
}


- (void)stopAllDetectors
{
    _isHeadingDetectorActive = NO;
    _isStepDetectorActive = NO;
    [self stopUpdates];
}

- (void)startUpdates
{
    if ([_motionManager isDeviceMotionAvailable] && ![_motionManager isDeviceMotionActive]) {
        [_motionManager setDeviceMotionUpdateInterval:1.0 /UPDATE_FREQUENY];
        [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            if (_isStepDetectorActive) {
                [_stepDetector pushSensorValue:motion.userAcceleration AtInterval:CFAbsoluteTimeGetCurrent()];
            }
            
            if (_isHeadingDetectorActive) {
                [_headingDetector pushSensorValue:motion.attitude AtInterval:CFAbsoluteTimeGetCurrent()];
//                [_magHeadingDetector pushSensorValue:motion.magneticField AtInterval:CFAbsoluteTimeGetCurrent()];
            }
            
            
        }];
    }
}


- (void)stopUpdates
{
    if ([_motionManager isDeviceMotionAvailable] && [_motionManager isDeviceMotionActive]) {
        [_motionManager stopDeviceMotionUpdates];
    }
}

- (void)headingDetector:(NPHeadingDetector *)headingDetector onHeadingChanged:(double)heading
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(motionDetector:onHeadingChanged:)]) {
        [self.delegate motionDetector:self onHeadingChanged:heading];
    }
}

- (void)headingDetector:(NPMagHeadingDetector *)headingDetector onMagHeadingChanged:(double)newHeading
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(motionDetector:onHeadingChanged:)]) {
//        [self.delegate motionDetector:self onHeadingChanged:newHeading];
//    }
}

- (void)stepDetector:(NPStepDetector *)stepDetector onStepEvent:(NPStepEvent *)step
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(motionDetector:onStepEvent:)]) {
        [self.delegate motionDetector:self onStepEvent:step];
    }
}

@end
