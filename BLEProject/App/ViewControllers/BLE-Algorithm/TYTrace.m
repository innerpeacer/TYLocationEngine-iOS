//
//  TYTrace.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/5.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYTrace.h"

@implementation TYTracePoint

- (id)initWithX:(double)x Y:(double)y Floor:(int)floor Index:(int)index
{
    return [[[self class] alloc] initWithX:x Y:y Floor:floor Index:index Timestamp:[[NSDate date] timeIntervalSince1970]];
}

- (id)initWithX:(double)x Y:(double)y Floor:(int)floor Index:(int)index Timestamp:(NSTimeInterval)timestamp
{
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
        self.floor = floor;
        self.timestamp = timestamp;
        self.index = index;
    }
    return self;
}

+ (TYTracePoint *)pointWithX:(double)x Y:(double)y Floor:(int)floor Index:(int)index
{
    return [[[self class] alloc] initWithX:x Y:y Floor:floor Index:index];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"TracePoint: (%f, %f, %d) Index: %d, Timestampe: %f", _x, _y, _floor, _index, _timestamp];
}

@end

@implementation TYTrace

- (id)init
{
    return [[[self class] alloc] initWithTraceID:nil];
}

- (id)initWithTraceID:(NSString *)tID
{
    return [[[self class] alloc] initWithTraceID:tID Timestamp:[[NSDate date] timeIntervalSince1970]];
}

- (id)initWithTraceID:(NSString *)tID Timestamp:(NSTimeInterval)timestamp
{
    self = [super init];
    if (self) {
        self.traceID = tID;
        self.timestamp = timestamp;
        self.points = [NSMutableArray array];
    }
    return self;
}

- (id)initWithTraceID:(NSString *)tID Timestamp:(NSTimeInterval)timestamp Points:(NSArray *)pointArray
{
    self = [super init];
    if (self) {
        self.traceID = tID;
        self.timestamp = timestamp;
        self.points = [NSMutableArray arrayWithArray:pointArray];
    }
    return self;
}

- (void)addTracePoint:(TYTracePoint *)point
{
    [self.points addObject:point];
}

- (void)addTracePointWithX:(double)x Y:(double)y Floor:(int)floor
{
    int currentIndex = 0;
    if (self.points.count > 0) {
        TYTracePoint *tp = [self.points lastObject];
        currentIndex = tp.index;
    }
    [self.points addObject:[TYTracePoint pointWithX:x Y:y Floor:floor Index:currentIndex]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Trace: %@, Points: %d", _traceID, (int)_points.count];
}

@end
