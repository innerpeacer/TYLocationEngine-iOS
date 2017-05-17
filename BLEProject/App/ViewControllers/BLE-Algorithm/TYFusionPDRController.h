//
//  TYFusionPDRController.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/15.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYRawDataCollection.h"
#import "TYFanRange.h"

@interface TYFusionPDRController : NSObject

- (id)initWithAngle:(double)angle;

@property (nonatomic, strong) TYLocalPoint *currentLocation;

- (void)setStartLocation:(TYLocalPoint *)start;
- (void)updateRawSignalEvent:(TYRawSignalEvent *)signal;

- (void)addStepEvent;
- (void)updateHeading:(double)newHeading;
- (void)reset;

@end
