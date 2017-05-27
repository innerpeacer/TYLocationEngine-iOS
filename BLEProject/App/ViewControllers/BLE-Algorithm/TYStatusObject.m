//
//  TYStatusObject.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/22.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYStatusObject.h"

//#define DEFAULT_STRIDE_SCALE 0.2
#define DEFAULT_STRIDE_LENGTH 0.5

//#define DEFAULT_ACCUMULATE_STEPS 5

//#define DEFAULT_TOLERANCE_DISTANCE 5

@interface TYStatusObject()
{
    TYFanRange *fanRange;
    LocationRangeStatus rangeStatus;
    double strideLength;
    double heading;
    
    TYRawSignalEvent *signalEvent;
}

@end

@implementation TYStatusObject
@synthesize fanRange = fanRange;
@synthesize rangeStatus = rangeStatus;
@synthesize currentStrideLength = strideLength;
@synthesize currentHeading = heading;
@synthesize currentSignal = signalEvent;

- (id)init
{
    self = [super init];
    if (self) {
        fanRange = [[TYFanRange alloc] init];
        rangeStatus = IP_Unknown;
        strideLength = DEFAULT_STRIDE_LENGTH;
    }
    return self;
}

- (void)updateSignal:(TYRawSignalEvent *)signal
{
    signalEvent = signal;
}

- (void)updateCenter:(TYLocalPoint *)c
{
    [fanRange updateCenter:c];
}

- (void)updateHeading:(double)h
{
    heading = h;
    [fanRange updateHeading:h];
}

- (void)updateRangeStatus:(TYLocalPoint *)lp
{
    switch ([fanRange getStatus:lp]) {
        case IP_Contain:
            BRTLog(@"Contain");
            rangeStatus = IP_Contain;
            strideLength = DEFAULT_STRIDE_LENGTH;
            break;
            
        case IP_Forward:
            BRTLog(@"Forward");
            rangeStatus = IP_Forward;
            strideLength = DEFAULT_STRIDE_LENGTH * 0.5;
            break;
            
        case IP_Backward:
            BRTLog(@"Backward");
            rangeStatus = IP_Backward;
            strideLength = DEFAULT_STRIDE_LENGTH * 1.5;
            break;
            
        default:
            BRTLog(@"Unknown");
            rangeStatus = IP_Unknown;
            break;
    }
}

- (NSArray *)firstSeveralBeacon:(int)count
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    if (signalEvent.beaconSignalArray && signalEvent.beaconSignalArray.count == 0) {
        return resultArray;
    }
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:signalEvent.beaconSignalArray];
    [tempArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        TYRawBeaconSignal *bs1 = obj1;
        TYRawBeaconSignal *bs2 = obj1;
        return bs1.rssi - bs2.rssi;
    }];
    
    int index = MIN((int)tempArray.count, count);
    for (int i = 0; i < index; ++i) {
        TYRawBeaconSignal *bs = tempArray[i];
        TYPublicBeacon *pb = [[TYPublicBeacon alloc] initWithUUID:bs.uuid Major:@(bs.major) Minor:@(bs.minor) Tag:nil Type:PUBLIC];
        pb.location = [TYLocalPoint pointWithX:bs.x Y:bs.y Floor:bs.floor];
        pb.rssi = bs.rssi;
        pb.accuracy = bs.accuracy;
        [resultArray addObject:pb];
    }
    return resultArray;
}

- (AGSGeometry *)fan
{
    return [fanRange toFanGeometry];
}

- (TYVectorLine *)signalLine
{
    NSArray *first2Beacons = [self firstSeveralBeacon:2];
    if (first2Beacons.count != 2) {
        return nil;
    }
    
    TYPublicBeacon *pb1 = first2Beacons[0];
    TYPublicBeacon *pb2 = first2Beacons[1];
    
    TYVectorLine *vLine = [[TYVectorLine alloc] initWithP1:pb1.location P2:pb2.location];
    vLine.name = @"SignalLine";
    return  vLine;
}

//- (AGSGeometry *)signalLine
//{
//    NSArray *first2Beacons = [self firstSeveralBeacon:2];
//    if (first2Beacons.count != 2) {
//        return nil;
//    }
//    
//    AGSMutablePolyline *line = [[AGSMutablePolyline alloc] init];
//    [line addPathToPolyline];
//    TYPublicBeacon *pb1 = first2Beacons[0];
//    TYPublicBeacon *pb2 = first2Beacons[1];
//    
//    TYVectorLine *vLine = [[TYVectorLine alloc] initWithP1:pb1.location P2:pb2.location];
//    return [vLine toGeometry];
//}

@end
