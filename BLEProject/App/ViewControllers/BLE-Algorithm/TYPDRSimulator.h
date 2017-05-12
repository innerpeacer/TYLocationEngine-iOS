//
//  TYPDRSimulator.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/11.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYRawDataCollection.h"

@class TYPDRSimulator;
@protocol TYPDRSimulatorDelegate <NSObject>

- (void)simulatorDidStart:(TYPDRSimulator *)simulator;
- (void)simulator:(TYPDRSimulator *)simulator replayStep:(TYRawStepEvent *)step;
- (void)simulator:(TYPDRSimulator *)simulator replayHeading:(TYRawHeadingEvent *)heading;
- (void)simulator:(TYPDRSimulator *)simulator replaySignal:(TYRawSignalEvent *)signal;
- (void)simulatorDidEnd:(TYPDRSimulator *)simulator;

@end

@interface TYPDRSimulator : NSObject

@property (nonatomic, weak) id<TYPDRSimulatorDelegate> delegate;

- (id)initWithData:(TYRawDataCollection *)data;

- (void)start;
- (void)stop;

- (void)pause;
- (void)resume;

- (void)setReplaySpeed:(double)speed;
@end
