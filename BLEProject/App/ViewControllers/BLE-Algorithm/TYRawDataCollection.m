//
//  TYRawDataCollection.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/9.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYRawDataCollection.h"

@implementation TYRawDataCollection

- (id)init
{
    return [[[self class] alloc] initWithDataID:nil];
}

- (id)initWithDataID:(NSString *)dID
{
    return [[[self class] alloc] initWithDataID:dID Timestamp:[[NSDate date] timeIntervalSince1970]];
}

- (id)initWithDataID:(NSString *)dID Timestamp:(NSTimeInterval)time
{
    self = [super init];
    if (self) {
        _dataID = dID;
        _timestamp = time;
        _stepEventArray = [[NSMutableArray alloc] init];
        _headingEventArray = [[NSMutableArray alloc] init];
        _signalEventArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithDataID:(NSString *)dID Timestamp:(NSTimeInterval)time Steps:(NSArray *)steps Headings:(NSArray *)headings Signals:(NSArray *)signals
{
    self = [super init];
    if (self) {
        _dataID = dID;
        _timestamp = time;
        _stepEventArray = [NSMutableArray arrayWithArray:steps];
        _headingEventArray = [NSMutableArray arrayWithArray:headings];
        _signalEventArray = [NSMutableArray arrayWithArray:signals];
    }
    return self;
}

- (void)addStepEvent:(TYRawStepEvent *)step
{
    [_stepEventArray addObject:step];
}

- (void)addHeadingEvent:(TYRawHeadingEvent *)heading
{
    [_headingEventArray addObject:heading];
}

- (void)addSignalEvent:(TYRawSignalEvent *)signal
{
    [_signalEventArray addObject:signal];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"DataID: %@, Steps: %d, Headings: %d, Signals: %d", _dataID, (int)_stepEventArray.count, (int)_headingEventArray.count, (int)_signalEventArray.count];
}

- (NSString *)detailedDescription
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.dataID forKey:@"DataID"];
    
    {
        NSMutableArray *stepArray = [NSMutableArray array];
        for (TYRawStepEvent *step in self.stepEventArray) {
            [stepArray addObject:[step description]];
        }
        [dict setObject:stepArray forKey:@"Steps"];
    }
    
    {
        NSMutableArray *headingArray = [NSMutableArray array];
        for (TYRawHeadingEvent *heading in self.headingEventArray) {
            [headingArray addObject:[heading description]];
        }
        [dict setObject:headingArray forKey:@"Headings"];
    }
    
    {
        NSMutableArray *signalArray = [NSMutableArray array];
        for (TYRawSignalEvent *signal in self.signalEventArray) {
            [signalArray addObject:[signal detailedDescription]];
        }
        [dict setObject:signalArray forKey:@"Signals"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

@implementation TYRawStepEvent

- (id)initWithTime:(NSTimeInterval)time
{
    self = [super init];
    if (self) {
        _timestamp = time;
    }
    return self;
}

+ (TYRawStepEvent *)newStepEvent
{
    return [[TYRawStepEvent alloc] initWithTime:BRTNow];
}

+ (TYRawStepEvent *)newStepEvent:(NSTimeInterval)time
{
    return [[TYRawStepEvent alloc] initWithTime:time];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Step: %f", _timestamp];
}

@end

@implementation TYRawHeadingEvent

- (id)initWithHeading:(double)heading Time:(NSTimeInterval)time
{
    self = [super init];
    if (self) {
        _heading = heading;
        _timestamp = time;
    }
    return self;
}

+ (TYRawHeadingEvent *)newHeadingEvent:(double)heading
{
    return [[TYRawHeadingEvent alloc] initWithHeading:heading Time:BRTNow];
}

+ (TYRawHeadingEvent *)newHeadingEvent:(double)heading Time:(NSTimeInterval)time
{
    return [[TYRawHeadingEvent alloc] initWithHeading:heading Time:time];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Heading: %f, Time: %f", _heading, _timestamp];
}

@end

@implementation TYRawBeaconSignal

- (id)initWithX:(double)x Y:(double)y Floor:(int)f UUID:(NSString *)uuid Major:(int)major Minor:(int)minor Rssi:(int)rssi Accuracy:(double)a
{
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
        _floor = f;
        _uuid = uuid;
        _major = major;
        _minor = minor;
        _rssi = rssi;
        _accuracy = a;
    }
    return self;
}

+ (TYRawBeaconSignal *)rawBeaconSignalWithPublicBeacon:(TYPublicBeacon *)pb
{
    return [[TYRawBeaconSignal alloc] initWithX:pb.location.x Y:pb.location.y Floor:pb.location.floor UUID:pb.UUID Major:pb.major.intValue Minor:pb.minor.intValue Rssi:pb.rssi Accuracy:pb.accuracy];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Rssi: %d, Dis: %f, Major: %d, Minor: %d", _rssi, _accuracy, _major, _minor];
}

@end

@implementation TYRawLocation

- (id)initWithX:(double)x Y:(double)y Floor:(int)floor
{
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
        _floor = floor;
    }
    return self;
}

+ (TYRawLocation *)rawLocationWithX:(double)x Y:(double)y Floor:(int)floor
{
    return [[TYRawLocation alloc] initWithX:x Y:y Floor:floor];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"RawLocation: (%f, %f, %d)", _x, _y, _floor];
}

@end

@implementation TYRawSignalEvent

- (id)init
{
    return [[[self class] alloc] initWithTime:BRTNow];
}

- (id)initWithTime:(NSTimeInterval)time
{
    self = [super init];
    if (self) {
        _timestamp = time;
        _beaconSignalArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithTime:(NSTimeInterval)time Location:(TYRawLocation *)location ImmediateLocation:(TYRawLocation *)immediateLocation SingalEvent:(NSArray *)singalEvent
{
    self = [super init];
    if (self) {
        _timestamp = time;
        _location = location;
        _immediateLocation = immediateLocation;
        _beaconSignalArray = [NSMutableArray arrayWithArray:singalEvent];
    }
    return self;
}

+ (TYRawSignalEvent *)newRawSingalEvent:(NSTimeInterval)time Location:(TYRawLocation *)location ImmediateLocation:(TYRawLocation *)immediateLocation SingalEvent:(NSArray *)singalEvent
{
//    TYRawSignalEvent *event = [[TYRawSignalEvent alloc] initWithTime:time];
//    event.location = location;
//    event.immediateLocation = immediateLocation;
//    [event.beaconSignalArray addObjectsFromArray:singalEvent];
//    return event;
    return [[TYRawSignalEvent alloc] initWithTime:time Location:location ImmediateLocation:immediateLocation SingalEvent:singalEvent];
}

- (NSString *)detailedDescription
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    {
        NSMutableArray *signalArray = [NSMutableArray array];
        for (TYRawBeaconSignal *signal in self.beaconSignalArray) {
            [signalArray addObject:[signal description]];
        }
        [dict setObject:signalArray forKey:@"Beacons"];
    }
    
    [dict setObject:@(self.timestamp) forKey:@"Time"];
    [dict setObject:[self.location description] forKey:@"Location"];
    [dict setObject:[self.immediateLocation description] forKey:@"ImmediateLocation"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

}

@end
