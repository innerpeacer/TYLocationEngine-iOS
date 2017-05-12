//
//  TYPDRSimulator.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/11.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYPDRSimulator.h"
#import "TYRawDataManager.h"

@interface TYPDRSimulator()
{
    TYRawDataCollection *data;
    NSTimeInterval startTime;
    NSTimer *replayTimer;
    
    NSArray *stepArray;
    NSArray *signalArray;
    NSArray *headingArray;
    
    int stepIndex;
    int signalIndex;
    int headingIndex;
    
    TYRawStepEvent *currentStep;
    TYRawHeadingEvent *currentHeading;
    TYRawSignalEvent *currentSignal;
    
    BOOL stepOver;
    BOOL signalOver;
    BOOL headingOver;
    
    BOOL isPaused;
    
    NSTimeInterval timeElasped;
    NSTimeInterval timePaused;
    NSTimeInterval pausingTime;
    
    double currentSpeed;
}

@end

@implementation TYPDRSimulator

- (id)initWithData:(TYRawDataCollection *)d
{
    self = [super init];
    if (self) {
        data = d;
        currentSpeed = 1;
        
        stepArray = data.stepEventArray;
        headingArray = data.headingEventArray;
        signalArray = data.signalEventArray;
    }
    
    return self;
}

- (void)start
{
    [self notifyStart];
    if (replayTimer) {
        [replayTimer invalidate];
        replayTimer = nil;
    }
    
    isPaused = NO;
    stepIndex = 0;
    signalIndex = 0;
    headingIndex = 0;
    
    stepOver = !(stepIndex < stepArray.count);
    headingOver = !(headingIndex < headingArray.count);
    signalOver = !(signalIndex < signalArray.count);
    
    startTime = BRTNow;
    timePaused = 0;
    
    replayTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(replay:) userInfo:nil repeats:YES];
    
    BRTLog(@"%@", data);
}

- (void)stop
{
    [replayTimer invalidate];
    replayTimer = nil;
}

- (void)pause
{
    BRTMethod
    if (isPaused) {
        return;
    }
    isPaused = YES;
    pausingTime = BRTNow;
}

- (void)resume
{
    BRTMethod
    if (!isPaused) {
        isPaused = NO;
    }
    isPaused = NO;
    
    timePaused += (BRTNow - pausingTime);
}

- (void)replay:(id)sender
{
    if (isPaused) {
//        BRTLog(@"Paused");
        return;
    }
    
    timeElasped = (BRTNow - startTime - timePaused) * currentSpeed;
    while (!stepOver) {
        currentStep = stepArray[stepIndex];
        if ((currentStep.timestamp - data.timestamp) < timeElasped) {
//            BRTLog(@"Fire Step %d: %@", stepIndex, currentStep);
            [self notifyStep:currentStep];
            ++stepIndex;
            stepOver = !(stepIndex < stepArray.count);
        } else {
            break;
        }
    }
    
    while (!headingOver) {
        currentHeading = headingArray[headingIndex];
        if ((currentHeading.timestamp - data.timestamp) < timeElasped) {
            //            BRTLog(@"Fire Heading %d: %@", headingIndex, currentHeading);
            [self notifyHeading:currentHeading];
            ++headingIndex;
            headingOver = !(headingIndex < headingArray.count);
        } else {
            break;
        }
    }
    
    while (!signalOver) {
        currentSignal = signalArray[signalIndex];
        if ((currentSignal.timestamp - data.timestamp) < timeElasped) {
//            BRTLog(@"Fire Signal %d: %@", signalIndex, currentSignal);
            [self notifySignal:currentSignal];
            ++signalIndex;
            signalOver = !(signalIndex < signalArray.count);
        } else {
            break;
        }
    }
    
    if (stepOver && headingOver && signalOver) {
        [self notifyEnd];
        NSTimer *timer = sender;
        [timer invalidate];
    }
}

- (void)notifyStart
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(simulatorDidStart:)]) {
        [self.delegate simulatorDidStart:self];
    }
}

- (void)notifyEnd
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(simulatorDidEnd:)]) {
        [self.delegate simulatorDidEnd:self];
    }
}

- (void)notifyStep:(TYRawStepEvent *)step
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(simulator:replayStep:)]) {
        [self.delegate simulator:self replayStep:step];
    }
}

- (void)notifyHeading:(TYRawHeadingEvent *)heading
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(simulator:replayHeading:)]) {
        [self.delegate simulator:self replayHeading:heading];
    }
}

- (void)notifySignal:(TYRawSignalEvent *)signal
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(simulator:replaySignal:)]) {
        [self.delegate simulator:self replaySignal:signal];
    }
}

- (void)setReplaySpeed:(double)speed
{
    if (speed < 0) {
        BRTLog(@"Speed %f < 0, Invalid",speed);
    }
    currentSpeed = speed;
}

@end
