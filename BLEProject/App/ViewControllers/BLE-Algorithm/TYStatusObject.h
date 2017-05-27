//
//  TYStatusObject.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/22.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYFanRange.h"
#import "TYRawDataCollection.h"
#import "TYVector2D.h"
#import "TYVectorLine.h"

@interface TYStatusObject : NSObject

@property (nonatomic, strong, readonly) TYFanRange *fanRange;
@property (nonatomic, readonly) LocationRangeStatus rangeStatus;
@property (nonatomic, readonly, strong) TYRawSignalEvent *currentSignal;
@property (nonatomic, readonly) double currentStrideLength;
@property (nonatomic, readonly) double currentHeading;

@property (nonatomic, strong, readonly) AGSGeometry *fan;
@property (nonatomic, strong, readonly) TYVectorLine *signalLine;

- (void)updateCenter:(TYLocalPoint *)c;
- (void)updateHeading:(double)h;
- (void)updateRangeStatus:(TYLocalPoint *)lp;
- (void)updateSignal:(TYRawSignalEvent *)signal;
- (NSArray *)firstSeveralBeacon:(int)count;

@end
