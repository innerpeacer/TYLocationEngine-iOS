//
//  TYTrace.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/5.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYTracePoint : NSObject
@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@property (nonatomic, assign) int floor;
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, assign) int index;

- (id)initWithX:(double)x Y:(double)y Floor:(int)floor Index:(int)index;
- (id)initWithX:(double)x Y:(double)y Floor:(int)floor Index:(int)index Timestamp:(NSTimeInterval)timestamp;
+ (TYTracePoint *)pointWithX:(double)x Y:(double)y Floor:(int)floor Index:(int)index;
@end


@interface TYTrace : NSObject
@property (nonatomic, strong) NSString *traceID;
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, strong) NSMutableArray *points;

- (id)initWithTraceID:(NSString *)tID;
- (id)initWithTraceID:(NSString *)tID Timestamp:(NSTimeInterval)timestamp;
- (id)initWithTraceID:(NSString *)tID Timestamp:(NSTimeInterval)timestamp Points:(NSArray *)pointArray;

- (void)addTracePoint:(TYTracePoint *)point;
- (void)addTracePointWithX:(double)x Y:(double)y Floor:(int)floor;
@end
