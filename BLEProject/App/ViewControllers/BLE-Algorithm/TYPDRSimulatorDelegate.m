//
//  TYPDRSimulatorDelegate.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/15.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYPDRSimulatorDelegate.h"
#import "TYPDRSimulator.h"

@implementation TYPDRSimulatorDelegateHelper

+ (void)notifyStart:(TYPDRSimulator *)simulator
{
    if (simulator.delegate && [simulator.delegate respondsToSelector:@selector(simulatorDidStart:)]) {
        [simulator.delegate simulatorDidStart:simulator];
    }
}

+ (void)notifyFinish:(TYPDRSimulator *)simulator
{
    if (simulator.delegate && [simulator.delegate respondsToSelector:@selector(simulatorDidFinish:)]) {
        [simulator.delegate simulatorDidFinish:simulator];
    }   
}

+ (void)notifyCancel:(TYPDRSimulator *)simulator
{
    if (simulator.delegate && [simulator.delegate respondsToSelector:@selector(simulatorDidCancel:)]) {
        [simulator.delegate simulatorDidCancel:simulator];
    }
}

+ (void)notifyPause:(TYPDRSimulator *)simulator
{
    if (simulator.delegate && [simulator.delegate respondsToSelector:@selector(simulatorDidPause:)]) {
        [simulator.delegate simulatorDidPause:simulator];
    }
}

+ (void)notifyResume:(TYPDRSimulator *)simulator
{
    if (simulator.delegate && [simulator.delegate respondsToSelector:@selector(simulatorDidResume:)]) {
        [simulator.delegate simulatorDidResume:simulator];
    }
}

+ (void)simulator:(TYPDRSimulator *)simulator notifyStep:(TYRawStepEvent *)step
{
    if (simulator.delegate && [simulator.delegate respondsToSelector:@selector(simulator:replayStep:)]) {
        [simulator.delegate simulator:simulator replayStep:step];
    }
}

+ (void)simulator:(TYPDRSimulator *)simulator notifyHeading:(TYRawHeadingEvent *)heading
{
    if (simulator.delegate && [simulator.delegate respondsToSelector:@selector(simulator:replayHeading:)]) {
        [simulator.delegate simulator:simulator replayHeading:heading];
    }
}

+ (void)simulator:(TYPDRSimulator *)simulator notifySignal:(TYRawSignalEvent *)signal
{
    if (simulator.delegate && [simulator.delegate respondsToSelector:@selector(simulator:replaySignal:)]) {
        [simulator.delegate simulator:simulator replaySignal:signal];
    }
}

@end
