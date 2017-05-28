////
////  TYRawDataCollection+Protobuf.m
////  BLEProject
////
////  Created by innerpeacer on 2017/5/9.
////  Copyright © 2017年 innerpeacer. All rights reserved.
////
//
//#import "TYRawDataCollection+Protobuf.h"
//
//@implementation TYRawDataCollection(Protobuf)
//
//- (TYRawDataCollectionPbf *)toPbf
//{
//    TYRawDataCollectionPbf *pbf = [[TYRawDataCollectionPbf alloc] init];
//    pbf.timestamp = self.timestamp;
//    pbf.dataId = self.dataID;
//    
//    pbf.stepEventsArray = [[NSMutableArray alloc] initWithCapacity:self.stepEventArray.count];
//    for (int i = 0; i < self.stepEventArray.count; ++i) {
//        TYRawStepEvent *step = self.stepEventArray[i];
//        pbf.stepEventsArray[i] = [step toPbf];
//    }
//    
//    pbf.headingEventsArray = [[NSMutableArray alloc] initWithCapacity:self.headingEventArray.count];
//    for (int i = 0; i < self.headingEventArray.count; ++i) {
//        TYRawHeadingEvent *heading = self.headingEventArray[i];
//        pbf.headingEventsArray[i] = [heading toPbf];
//    }
//    
//    pbf.signalEventsArray = [[NSMutableArray alloc] initWithCapacity:self.signalEventArray.count];
//    for (int i = 0; i < self.signalEventArray.count; ++i) {
//        TYRawSignalEvent *signal = self.signalEventArray[i];
//        pbf.signalEventsArray[i] = [signal toPbf];
//    }
//    
//    return pbf;
//}
//
//- (NSData *)data
//{
//    return [[self toPbf] data];
//}
//
//- (id)initWithPbf:(TYRawDataCollectionPbf *)pbf
//{
//    NSMutableArray *stepArray = [[NSMutableArray alloc] initWithCapacity:pbf.stepEventsArray.count];
//    for (int i = 0; i < pbf.stepEventsArray.count; ++i) {
//        stepArray[i] = [[TYRawStepEvent alloc] initWithPbf:pbf.stepEventsArray[i]];
//    }
//    
//    NSMutableArray *headingArray = [[NSMutableArray alloc] initWithCapacity:pbf.headingEventsArray.count];
//    for (int i = 0; i < pbf.headingEventsArray.count; ++i) {
//        headingArray[i] = [[TYRawHeadingEvent alloc] initWithPbf:pbf.headingEventsArray[i]];
//    }
//    
//    NSMutableArray *signalArray = [[NSMutableArray alloc] initWithCapacity:pbf.signalEventsArray.count];
//    for (int i = 0; i < pbf.signalEventsArray.count; ++i) {
//        signalArray[i] = [[TYRawSignalEvent alloc] initWithPbf:pbf.signalEventsArray[i]];
//    }
//    
//    return [[[self class] alloc] initWithDataID:pbf.dataId Timestamp:pbf.timestamp Steps:stepArray Headings:headingArray Signals:signalArray];
//}
//
//+ (TYRawDataCollection *)withData:(NSData *)data error:(NSError *)err
//{
//    TYRawDataCollectionPbf *pbf = [[TYRawDataCollectionPbf alloc] initWithData:data error:&err];
//    if (err) {
//        NSLog(@"Error: %@", err.localizedDescription);
//        return nil;
//    }
//    return [[TYRawDataCollection alloc] initWithPbf:pbf];
//}
//
//@end
//
//@implementation TYRawStepEvent(Protobuf)
//
//- (TYRawStepEventPbf *)toPbf
//{
//    TYRawStepEventPbf *pbf = [[TYRawStepEventPbf alloc] init];
//    pbf.timestamp = self.timestamp;
//    return pbf;
//}
//
//- (NSData *)data
//{
//    return [[self toPbf] data];
//}
//
//- (id)initWithPbf:(TYRawStepEventPbf *)pbf
//{
//    return [[[self class] alloc] initWithTime:pbf.timestamp];
//}
//
//+ (TYRawStepEvent *)withData:(NSData *)data error:(NSError *)err
//{
//    TYRawStepEventPbf *pbf = [[TYRawStepEventPbf alloc] initWithData:data error:&err];
//    if (err) {
//        NSLog(@"Error: %@", err.localizedDescription);
//        return nil;
//    }
//    return [[TYRawStepEvent alloc] initWithPbf:pbf];
//}
//
//@end
//
//@implementation TYRawHeadingEvent(Protobuf)
//
//- (TYRawHeadingEventPbf *)toPbf
//{
//    TYRawHeadingEventPbf *pbf = [[TYRawHeadingEventPbf alloc] init];
//    pbf.timestamp = self.timestamp;
//    pbf.heading = self.heading;
//    return pbf;
//}
//
//- (NSData *)data
//{
//    return [[self toPbf] data];
//}
//
//- (id)initWithPbf:(TYRawHeadingEventPbf *)pbf
//{
//    return [[[self class] alloc] initWithHeading:pbf.heading Time:pbf.timestamp];
//}
//
//+ (TYRawHeadingEvent *)withData:(NSData *)data error:(NSError *)err
//{
//    TYRawHeadingEventPbf *pbf = [[TYRawHeadingEventPbf alloc] initWithData:data error:&err];
//    if (err) {
//        NSLog(@"Error: %@", err.localizedDescription);
//        return nil;
//    }
//    return [[TYRawHeadingEvent alloc] initWithPbf:pbf];
//}
//
//@end
//
//@implementation TYRawBeaconSignal(Protobuf)
//
//- (TYRawBeaconSignalPbf *)toPbf
//{
//    TYRawBeaconSignalPbf *pbf = [[TYRawBeaconSignalPbf alloc] init];
//    pbf.uuid = self.uuid;
//    pbf.major = self.major;
//    pbf.minor = self.minor;
//
//    pbf.x = self.x;
//    pbf.y = self.y;
//    pbf.floor = self.floor;
//
//    pbf.rssi = self.rssi;
//    pbf.accuracy = self.accuracy;
//    return pbf;
//}
//
//- (NSData *)data
//{
//    return [[self toPbf] data];
//}
//
//- (id)initWithPbf:(TYRawBeaconSignalPbf *)pbf
//{
//    return [[[self class] alloc] initWithX:pbf.x Y:pbf.y Floor:pbf.floor UUID:pbf.uuid Major:pbf.major Minor:pbf.minor Rssi:pbf.rssi Accuracy:pbf.accuracy
//            ];
//}
//
//
//+ (TYRawBeaconSignal *)withData:(NSData *)data error:(NSError *)err
//{
//    TYRawBeaconSignalPbf *pbf = [[TYRawBeaconSignalPbf alloc] initWithData:data error:&err];
//    if (err) {
//        NSLog(@"Error: %@", err.localizedDescription);
//        return nil;
//    }
//    return [[TYRawBeaconSignal alloc] initWithPbf:pbf];
//}
//
//@end
//
//@implementation TYRawLocation(Protobuf)
//
//- (TYRawLocationPbf *)toPbf
//{
//    TYRawLocationPbf *pbf = [[TYRawLocationPbf alloc] init];
//    pbf.x = self.x;
//    pbf.y = self.y;
//    pbf.floor = self.floor;
//    return pbf;
//}
//
//
//- (NSData *)data
//{
//    return [[self toPbf] data];
//}
//
//- (id)initWithPbf:(TYRawLocationPbf *)pbf
//{
//    return [[[self class] alloc] initWithX:pbf.x Y:pbf.y Floor:pbf.floor];
//}
//
//+ (TYRawLocation *)withData:(NSData *)data error:(NSError *)err
//{
//    TYRawLocationPbf *pbf = [[TYRawLocationPbf alloc] initWithData:data error:&err];
//    if (err) {
//        NSLog(@"Error: %@", err.localizedDescription);
//        return nil;
//    }
//    return [[TYRawLocation alloc] initWithPbf:pbf];
//}
//
//@end
//
//@implementation TYRawSignalEvent(Protobuf)
//
//- (TYRawSignalEventPbf *)toPbf
//{
//    TYRawSignalEventPbf *pbf = [[TYRawSignalEventPbf alloc] init];
//    pbf.timestamp = self.timestamp;
//    pbf.location = [self.location toPbf];
//    pbf.immediateLocation = [self.immediateLocation toPbf];
//    pbf.beaconsArray = [NSMutableArray arrayWithCapacity:self.beaconSignalArray.count];
//    for (int i = 0; i < self.beaconSignalArray.count; ++i) {
//        TYRawBeaconSignal *rbs = self.beaconSignalArray[i];
//        pbf.beaconsArray[i] = [rbs toPbf];
//    }
//    return pbf;
//}
//
//- (NSData *)data
//{
//    return [[self toPbf] data];
//}
//
//- (id)initWithPbf:(TYRawSignalEventPbf *)pbf
//{
//    TYRawLocation *location = [[TYRawLocation alloc] initWithPbf:pbf.location];
//    TYRawLocation *immediateLocation = [[TYRawLocation alloc] initWithPbf:pbf.immediateLocation];
//    NSMutableArray *signalEvent = [NSMutableArray arrayWithCapacity:pbf.beaconsArray.count];
//    for (int i = 0; i < pbf.beaconsArray.count; ++i) {
//        signalEvent[i] = [[TYRawBeaconSignal alloc] initWithPbf:pbf.beaconsArray[i]];
//    }
//    return [[[self class] alloc] initWithTime:pbf.timestamp Location:location ImmediateLocation:immediateLocation SingalEvent:signalEvent];
//}
//
//+ (TYRawSignalEvent *)withData:(NSData *)data error:(NSError *)err
//{
//    TYRawSignalEventPbf *pbf = [[TYRawSignalEventPbf alloc] initWithData:data error:&err];
//    if (err) {
//        NSLog(@"Error: %@", err.localizedDescription);
//        return nil;
//    }
//    return [[TYRawSignalEvent alloc] initWithPbf:pbf];
//}
//
//@end
