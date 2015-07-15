//
//  CAStepDetector.m
//  CloudAtlasTestProject
//
//  Created by innerpeacer on 15/1/30.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "NPStepDetector.h"

#import "NPMovingAverageTD.h"
#import "NPCumulativeSingalPowerTD.h"

#import "NPStepEvent.h"

#define MAVALUE_LENGTH 4

#define MA1_WINDOW 0.2
#define MA2_WINDOW 1.0
#define MAX_STRIDE_DURATION 2.0
#define POWER_CUTOFF_VALUE 1000.0
#define GRAVITY_CONSTANT 9.8

@interface NPStepDetector()
{
    float _MAValues[MAVALUE_LENGTH];
    NSMutableArray *_MAFilters;
    NPCumulativeSingalPowerTD *_csp_Filter;

    BOOL _MASwapState;
    BOOL _StepDetected;
    BOOL _SingalPowerCutoff;

    CFTimeInterval _lastStepTimeStamp;
    double _strideDuration;

    double _WindowMA1;
    double _WindowMA2;
    double _powerCutoff;
}

@end

@implementation NPStepDetector

+ (NPStepDetector *)newDefaultStepDetector
{
    return [[NPStepDetector alloc] initWithWindow1:MA1_WINDOW Window2:MA2_WINDOW PowerCutoff:POWER_CUTOFF_VALUE];
}

- (id)initWithWindow1:(double)w1 Window2:(double)w2 PowerCutoff:(double)pc
{
    self = [super init];
    if (self) {
        
        _WindowMA1 = w1;
        _WindowMA2 = w2;
        _powerCutoff = pc;
        
        _MASwapState = YES;
        _StepDetected = NO;
        _SingalPowerCutoff = YES;
        
        _MAFilters = [[NSMutableArray alloc] init];
        [_MAFilters addObject:[[NPMovingAverageTD alloc] initWithWindow:_WindowMA1]];
        [_MAFilters addObject:[[NPMovingAverageTD alloc] initWithWindow:_WindowMA1]];
        [_MAFilters addObject:[[NPMovingAverageTD alloc] initWithWindow:_WindowMA2]];
        
        _csp_Filter = [[NPCumulativeSingalPowerTD alloc] init];
        
    }
    return self;
}

-(void)pushSensorValue:(CMAcceleration) accer AtInterval:(CFTimeInterval) timeStamp{
    //    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    double tmpValue = accer.z * GRAVITY_CONSTANT;
    
    _MAValues[0] = tmpValue;
    
    for (int i = 1; i < 3; ++i) {
        [[_MAFilters objectAtIndex:i] push:@(tmpValue) At:timeStamp];
        _MAValues[i] = [[_MAFilters objectAtIndex:i] average];
        tmpValue = _MAValues[i];
    }
    
    _StepDetected = NO;
    BOOL newSwapState = _MAValues[1] > _MAValues[2];
    if (newSwapState != _MASwapState) {
        _MASwapState = newSwapState;
        if (_MASwapState) {
            _StepDetected = YES;
        }
    }
    
    [_csp_Filter push:@(_MAValues[1] - _MAValues[2]) At:timeStamp];
    _MAValues[3] = _csp_Filter.power;
    _SingalPowerCutoff = _MAValues[3] < _powerCutoff;
    
    if (_StepDetected) {
        [_csp_Filter reset];
    }
    
    if (_StepDetected && !_SingalPowerCutoff) {
        _strideDuration = [self getStrideDuration];
        if (self.delegate && [self.delegate respondsToSelector:@selector(stepDetector:onStepEvent:)]) {
            [self.delegate stepDetector:self onStepEvent:[NPStepEvent newStepWithProbability:1.0 Duration:_strideDuration]];
        }
    }
}

- (double)getStrideDuration
{
    CFTimeInterval currentStepTimesStamp = CFAbsoluteTimeGetCurrent();
    double strideDuration;
    strideDuration = currentStepTimesStamp - _lastStepTimeStamp;
    
    if (strideDuration > MAX_STRIDE_DURATION) {
        strideDuration = -1.0;
    }
    _lastStepTimeStamp = currentStepTimesStamp;
    return strideDuration;
}

- (void)reset
{
    for (int i = 0; i < MAVALUE_LENGTH; ++i) {
        _MAValues[i] = 0;
    }
    
    for(NPMovingAverageTD *mvgTD in _MAFilters)
    {
        [mvgTD reset];
    }
    
    _MASwapState = YES;
    _StepDetected = NO;
    _powerCutoff = YES;
    
    [_csp_Filter reset];
}


@end
