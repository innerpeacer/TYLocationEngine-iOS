//
//  TYPDRSimulator.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/11.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYRawDataCollection.h"
#import "TYPDRSimulatorDelegate.h"

//@class TYPDRSimulator;
//@protocol TYPDRSimulatorDelegate <NSObject>
//
//- (void)simulatorDidStart:(TYPDRSimulator *)simulator;
//- (void)simulatorDidEnd:(TYPDRSimulator *)simulator;
//- (void)simulatorDidCancel:(TYPDRSimulator *)simulator;
//- (void)simulatorDidPause:(TYPDRSimulator *)simulator;
//- (void)simulatorDidResume:(TYPDRSimulator *)simulator;
//
//
//- (void)simulator:(TYPDRSimulator *)simulator replayStep:(TYRawStepEvent *)step;
//- (void)simulator:(TYPDRSimulator *)simulator replayHeading:(TYRawHeadingEvent *)heading;
//- (void)simulator:(TYPDRSimulator *)simulator replaySignal:(TYRawSignalEvent *)signal;
//
//
//@end

@interface TYPDRSimulator : NSObject

@property (nonatomic, weak) id<TYPDRSimulatorDelegate> delegate;

- (id)initWithData:(TYRawDataCollection *)data;

- (void)start;
- (void)cancel;

- (void)pause;
- (void)resume;

- (void)setReplaySpeed:(double)speed;
@end
