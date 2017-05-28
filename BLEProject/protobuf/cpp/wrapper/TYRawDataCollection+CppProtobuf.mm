//
//  TYRawDataCollection+CppProtobuf.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/27.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYRawDataCollection+CppProtobuf.h"

@implementation TYRawDataCollection(CppProtobuf)

- (void)toPbfRecord:(IPXPbfDBRecord *)record
{
    record->dataType = IPX_PBF_RAW_DATA;
    record->dataID = [self.dataID UTF8String];
    TYRawDataCollectionPbf *pbf = new TYRawDataCollectionPbf();
    [self toCppPbf:pbf];
    record->dataLength = pbf->ByteSizeLong();
    record->data = new char[record->dataLength];
    pbf->SerializeToArray(record->data, record->dataLength);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY年MM月dd日 HH:mm:ss";
    NSString *date = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.timestamp]];
    record->dataDescription = [date UTF8String];
}

+ (TYRawDataCollection *)fromCppPbfDBRecord:(innerpeacer::rawdata::IPXPbfDBRecord *)record
{
    TYRawDataCollectionPbf pbf;
    pbf.ParseFromArray(record->data, record->dataLength);
    return [[TYRawDataCollection alloc] initWithPbf:&pbf];
}

- (void)toCppPbf:(TYRawDataCollectionPbf *)pbf
{
    pbf->set_timestamp(self.timestamp);
    pbf->set_dataid([self.dataID UTF8String]);
    
    for (int i = 0; i < self.stepEventArray.count; ++i) {
        TYRawStepEvent *step = self.stepEventArray[i];
        TYRawStepEventPbf *sPbf = pbf->add_stepevents();
        [step toCppPbf:sPbf];
    }
    
    for (int i = 0; i < self.headingEventArray.count; ++i) {
        TYRawHeadingEvent *heading = self.headingEventArray[i];
        TYRawHeadingEventPbf *hPbf = pbf->add_headingevents();
        [heading toCppPbf:hPbf];
    }
    
    for (int i = 0; i < self.signalEventArray.count; ++i) {
        TYRawSignalEvent *signal = self.signalEventArray[i];
        TYRawSignalEventPbf *sPbf = pbf->add_signalevents();
        [signal toCppPbf:sPbf];
    }
}

- (id)initWithPbf:(TYRawDataCollectionPbf *)pbf
{
    NSMutableArray *stepArray = [[NSMutableArray alloc] initWithCapacity:pbf->stepevents_size()];
    for (int i = 0; i < pbf->stepevents_size(); ++i) {
        stepArray[i] = [[TYRawStepEvent alloc] initWithPbf:pbf->mutable_stepevents(i)];
    }
    
    NSMutableArray *headingArray = [[NSMutableArray alloc] initWithCapacity:pbf->headingevents_size()];
    for (int i = 0; i < pbf->headingevents_size(); ++i) {
        headingArray[i] = [[TYRawHeadingEvent alloc] initWithPbf:pbf->mutable_headingevents(i)];
    }
    
    NSMutableArray *signalArray = [[NSMutableArray alloc] initWithCapacity:pbf->signalevents_size()];
    for (int i = 0; i < pbf->signalevents_size(); ++i) {
        signalArray[i] = [[TYRawSignalEvent alloc] initWithPbf:pbf->mutable_signalevents(i)];
    }
    
    return [[[self class] alloc] initWithDataID:[NSString stringWithUTF8String:pbf->dataid().c_str()] Timestamp:pbf->timestamp() Steps:stepArray Headings:headingArray Signals:signalArray];
}

@end

@implementation TYRawStepEvent(CppProtobuf)

- (void)toCppPbf:(innerpeacer::rawdata::TYRawStepEventPbf *)pbf
{
    pbf->set_timestamp(self.timestamp);
}

- (id)initWithPbf:(TYRawStepEventPbf *)pbf
{
    return [[[self class] alloc] initWithTime:pbf->timestamp()];
}

@end

@implementation TYRawHeadingEvent(CppProtobuf)

- (void)toCppPbf:(innerpeacer::rawdata::TYRawHeadingEventPbf *)pbf
{
    pbf->set_timestamp(self.timestamp);
    pbf->set_heading(self.heading);
}

- (id)initWithPbf:(TYRawHeadingEventPbf *)pbf
{
    return [[[self class] alloc] initWithHeading:pbf->heading() Time:pbf->timestamp()];
}

@end

@implementation TYRawBeaconSignal(CppProtobuf)

- (void)toCppPbf:(innerpeacer::rawdata::TYRawBeaconSignalPbf *)pbf
{
    pbf->set_uuid([self.uuid UTF8String]);
    pbf->set_major(self.major);
    pbf->set_minor(self.minor);
    
    pbf->set_x(self.x);
    pbf->set_y(self.y);
    pbf->set_floor(self.floor);
    
    pbf->set_rssi(self.rssi);
    pbf->set_accuracy(self.accuracy);
}

- (id)initWithPbf:(TYRawBeaconSignalPbf *)pbf
{
    return [[[self class] alloc] initWithX:pbf->x() Y:pbf->y() Floor:pbf->floor() UUID:[NSString stringWithUTF8String:pbf->uuid().c_str()] Major:pbf->major() Minor:pbf->minor() Rssi:pbf->rssi() Accuracy:pbf->accuracy()
            ];
}

@end

@implementation TYRawLocation(CppProtobuf)

- (void)toCppPbf:(innerpeacer::rawdata::TYRawLocationPbf *)pbf
{
    pbf->set_x(self.x);
    pbf->set_y(self.y);
    pbf->set_floor(self.floor);
}

- (id)initWithPbf:(TYRawLocationPbf *)pbf
{
    return [[[self class] alloc] initWithX:pbf->x() Y:pbf->y() Floor:pbf->floor()];
}

@end

@implementation TYRawSignalEvent(CppProtobuf)

- (void)toCppPbf:(innerpeacer::rawdata::TYRawSignalEventPbf *)pbf
{
    pbf->set_timestamp(self.timestamp);
    
    TYRawLocationPbf *locationPbf = new TYRawLocationPbf();
    [self.location toCppPbf:locationPbf];
    pbf->set_allocated_location(locationPbf);
    
    TYRawLocationPbf *immeLocationPbf = new TYRawLocationPbf();
    [self.immediateLocation toCppPbf:immeLocationPbf];
    pbf->set_allocated_immediatelocation(immeLocationPbf);
    
    for (int i = 0 ; i < self.beaconSignalArray.count; ++i) {
        TYRawBeaconSignal *bs = self.beaconSignalArray[i];
        TYRawBeaconSignalPbf *bsPbf = pbf->add_beacons();
        [bs toCppPbf:bsPbf];
    }
}

- (id)initWithPbf:(TYRawSignalEventPbf *)pbf
{
    TYRawLocation *location = [[TYRawLocation alloc] initWithPbf:pbf->mutable_location()];
    TYRawLocation *immediateLocation = [[TYRawLocation alloc] initWithPbf:pbf->mutable_immediatelocation()];
    NSMutableArray *signalEvent = [NSMutableArray arrayWithCapacity:pbf->beacons_size()];
    for (int i = 0; i < pbf->beacons_size(); ++i) {
        signalEvent[i] = [[TYRawBeaconSignal alloc] initWithPbf:pbf->mutable_beacons(i)];
    }
    return [[[self class] alloc] initWithTime:pbf->timestamp() Location:location ImmediateLocation:immediateLocation SingalEvent:signalEvent];
}

@end

