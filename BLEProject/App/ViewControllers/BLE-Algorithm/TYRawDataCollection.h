//
//  TYRawDataCollection.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/9.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYPublicBeacon.h"

@interface TYRawStepEvent : NSObject
@property (nonatomic, assign) NSTimeInterval timestamp;

- (id)initWithTime:(NSTimeInterval)time;
+ (TYRawStepEvent *)newStepEvent;
+ (TYRawStepEvent *)newStepEvent:(NSTimeInterval)time;

@end

@interface TYRawHeadingEvent : NSObject
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, assign) double heading;

- (id)initWithHeading:(double)heading Time:(NSTimeInterval)time;
+ (TYRawHeadingEvent *)newHeadingEvent:(double)heading;
+ (TYRawHeadingEvent *)newHeadingEvent:(double)heading Time:(NSTimeInterval)time;

@end

@interface TYRawBeaconSignal : NSObject
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, assign) int major;
@property (nonatomic, assign) int minor;

@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@property (nonatomic, assign) int floor;

@property (nonatomic, assign) int rssi;
@property (nonatomic, assign) double accuracy;

- (id)initWithX:(double)x Y:(double)y Floor:(int)f UUID:(NSString *)uuid Major:(int)major Minor:(int)minor Rssi:(int)rssi Accuracy:(double)a;
+ (TYRawBeaconSignal *)rawBeaconSignalWithPublicBeacon:(TYPublicBeacon *)pb;
@end

@interface TYRawLocation : NSObject
@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@property (nonatomic, assign) int floor;
- (id)initWithX:(double)x Y:(double)y Floor:(int)floor;
+ (TYRawLocation *)rawLocationWithX:(double)x Y:(double)y Floor:(int)floor;
@end

@interface TYRawSignalEvent : NSObject
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, strong) NSMutableArray *beaconSignalArray;
@property (nonatomic, strong) TYRawLocation *location;
@property (nonatomic, strong) TYRawLocation *immediateLocation;

- (id)initWithTime:(NSTimeInterval)time Location:(TYRawLocation *)location ImmediateLocation:(TYRawLocation *)immediateLocation SingalEvent:(NSArray *)singalEvent;
+ (TYRawSignalEvent *)newRawSingalEvent:(NSTimeInterval)time Location:(TYRawLocation *)location ImmediateLocation:(TYRawLocation *)immediateLocation SingalEvent:(NSArray *)singalEvent;
- (NSString *)detailedDescription;

@end

@interface TYRawDataCollection : NSObject
@property (nonatomic, strong) NSString *dataID;
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, strong) NSMutableArray *stepEventArray;
@property (nonatomic, strong) NSMutableArray *headingEventArray;
@property (nonatomic, strong) NSMutableArray *signalEventArray;

- (id)initWithDataID:(NSString *)dID;
- (id)initWithDataID:(NSString *)dID Timestamp:(NSTimeInterval)time;
- (id)initWithDataID:(NSString *)dID Timestamp:(NSTimeInterval)time Steps:(NSArray *)steps Headings:(NSArray *)headings Signals:(NSArray *)signals;

- (void)addStepEvent:(TYRawStepEvent *)step;
- (void)addHeadingEvent:(TYRawHeadingEvent *)heading;
- (void)addSignalEvent:(TYRawSignalEvent *)signal;

- (NSString *)detailedDescription;

@end
