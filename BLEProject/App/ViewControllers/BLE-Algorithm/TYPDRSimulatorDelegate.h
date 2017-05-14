//
//  TYPDRSimulatorDelegate.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/15.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYRawDataCollection.h"

@class TYPDRSimulator;
@protocol TYPDRSimulatorDelegate <NSObject>

@optional
- (void)simulatorDidStart:(TYPDRSimulator *)simulator;
- (void)simulatorDidFinish:(TYPDRSimulator *)simulator;
- (void)simulatorDidCancel:(TYPDRSimulator *)simulator;
- (void)simulatorDidPause:(TYPDRSimulator *)simulator;
- (void)simulatorDidResume:(TYPDRSimulator *)simulator;


- (void)simulator:(TYPDRSimulator *)simulator replayStep:(TYRawStepEvent *)step;
- (void)simulator:(TYPDRSimulator *)simulator replayHeading:(TYRawHeadingEvent *)heading;
- (void)simulator:(TYPDRSimulator *)simulator replaySignal:(TYRawSignalEvent *)signal;

@end

@interface TYPDRSimulatorDelegateHelper : NSObject
+ (void)notifyStart:(TYPDRSimulator *)simulator;
+ (void)notifyFinish:(TYPDRSimulator *)simulator;
+ (void)notifyCancel:(TYPDRSimulator *)simulator;
+ (void)notifyPause:(TYPDRSimulator *)simulator;
+ (void)notifyResume:(TYPDRSimulator *)simulator;

+ (void)simulator:(TYPDRSimulator *)simulator notifyStep:(TYRawStepEvent *)step;
+ (void)simulator:(TYPDRSimulator *)simulator notifyHeading:(TYRawHeadingEvent *)heading;
+ (void)simulator:(TYPDRSimulator *)simulator notifySignal:(TYRawSignalEvent *)signal;
@end
