//
//  TYPDRSimulator.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/17.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYPDRSimulator.h"
#import "TYRawDataManager.h"

@interface TYPDRSimulator()
{
    TYRawDataCollection *data;
    NSTimer *replayTimer;
    
    NSMutableArray *allEventArray;
    TYRawEvent *currentEvent;
    int eventIndex;
    BOOL isEventOver;
    BOOL isPaused;
    
    NSTimeInterval startTime;
    NSTimeInterval currentReplayTime;
    NSTimeInterval replayStartTime;
    NSTimeInterval replayStep;
    NSTimeInterval replaySpeed;
}

@end

@implementation TYPDRSimulator

- (id)initWithData:(TYRawDataCollection *)d
{
    self = [super init];
    if (self) {
        data = d;
        replaySpeed = 1;
        replayStep = 0.01;
        
        allEventArray = [[NSMutableArray alloc] init];
        [allEventArray addObjectsFromArray:data.stepEventArray];
        [allEventArray addObjectsFromArray:data.headingEventArray];
        [allEventArray addObjectsFromArray:data.signalEventArray];
        [allEventArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            TYRawEvent *e1 = obj1;
            TYRawEvent *e2 = obj2;
            return e1.timestamp - e2.timestamp;
        }];
    }
    
    return self;
}

- (NSTimeInterval)calcualteCurrentReplayTime
{
    BOOL useStep = YES;
//    useStep = NO;
    if (useStep) {
        return replayStartTime + (BRTNow - startTime) * replaySpeed;
    } else {
        return currentReplayTime + replayStep * replaySpeed;
    }
}

- (void)start
{
    [TYPDRSimulatorDelegateHelper notifyStart:self];
    
    if (replayTimer) {
        [replayTimer invalidate];
        replayTimer = nil;
    }
    
    isPaused = NO;
    eventIndex = 0;
    isEventOver = !(eventIndex < allEventArray.count);
    
    startTime = BRTNow;
    replayStartTime = data.timestamp - 0.02;
    currentReplayTime = replayStartTime;
    
    replayTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(replay:) userInfo:nil repeats:YES];
}

- (void)cancel
{
    [replayTimer invalidate];
    replayTimer = nil;
    [TYPDRSimulatorDelegateHelper notifyCancel:self];
}

- (void)pause
{
    BRTMethod
    if (isPaused) {
        return;
    }
    isPaused = YES;
    [TYPDRSimulatorDelegateHelper notifyPause:self];
}

- (void)resume
{
    BRTMethod
    if (!isPaused) {
        isPaused = NO;
    }
    isPaused = NO;
    
    startTime = BRTNow;
    replayStartTime = currentReplayTime;
    [TYPDRSimulatorDelegateHelper notifyResume:self];
}

- (void)replay:(id)sender
{
    if (isPaused) {
        return;
    }
    
    NSMutableArray *eventToFire = [[NSMutableArray alloc] init];
    currentReplayTime = [self calcualteCurrentReplayTime];
    
    while (!isEventOver) {
        currentEvent = allEventArray[eventIndex];
        if (currentEvent.timestamp < currentReplayTime) {
            [eventToFire addObject:currentEvent];
            ++eventIndex;
            isEventOver = !(eventIndex < allEventArray.count);
        } else {
            break;
        }
    }
    
    
    if (eventToFire.count != 0) {
        for (TYRawEvent *event in eventToFire) {
            [TYPDRSimulatorDelegateHelper simulator:self nofityRawEvent:event];
        }
    }
    
    if (isEventOver) {
        [TYPDRSimulatorDelegateHelper notifyFinish:self];
        NSTimer *timer = sender;
        [timer invalidate];
    }
}

- (void)setReplaySpeed:(double)speed
{
    if (speed < 0) {
        BRTLog(@"Speed %f < 0, Invalid",speed);
    }
    replaySpeed = speed;
}

@end

