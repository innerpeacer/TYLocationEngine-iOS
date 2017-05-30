//
//  TYTrace+CppProtobuf.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/30.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYTrace+CppProtobuf.h"

@implementation TYTracePoint(CppProtobuf)

- (void)toCppPbf:(innerpeacer::trace::TYTracePointPbf *)pbf
{
    pbf->set_x(self.x);
    pbf->set_y(self.y);
    pbf->set_floor(self.floor);
    pbf->set_timestamp(self.timestamp);
    pbf->set_index(self.index);
}

- (id)initWithPbf:(innerpeacer::trace::TYTracePointPbf *)pbf
{
    self = [super init];
    if (self) {
        self.x = pbf->x();
        self.y = pbf->y();
        self.floor = pbf->floor();
        self.timestamp = pbf->timestamp();
        self.index = pbf->index();
    }
    return self;
}

@end

@implementation TYTrace(CppProtobuf)

- (void)toPbfRecord:(innerpeacer::rawdata::IPXPbfDBRecord *)record
{
    record->dataType = IPX_PBF_TRACE_DATA;
    record->dataID = [self.traceID UTF8String];
    
    TYTracePbf *pbf = new TYTracePbf();
    [self toCppPbf:pbf];
    record->dataLength = pbf->ByteSizeLong();
    record->data = new char[record->dataLength];
    pbf->SerializeToArray(record->data, record->dataLength);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY年MM月dd日 HH:mm:ss";
    NSString *date = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.timestamp]];
    record->dataDescription = [date UTF8String];
}

+ (TYTrace *)fromCppPbfDBRecord:(IPXPbfDBRecord *)record
{
    TYTracePbf pbf;
    pbf.ParseFromArray(record->data, record->dataLength);
    return [[TYTrace alloc] initWithPbf:&pbf];
}

- (void)toCppPbf:(innerpeacer::trace::TYTracePbf *)pbf
{
    pbf->set_timestamp(self.timestamp);
    pbf->set_traceid([self.traceID UTF8String]);
    
    for (int i = 0; i < self.points.count; ++i) {
        TYTracePoint *tp = self.points[i];
        TYTracePointPbf *tPbf = pbf->add_points();
        [tp toCppPbf:tPbf];
    }
}

- (id)initWithPbf:(innerpeacer::trace::TYTracePbf *)pbf
{
    NSMutableArray *pointArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < pbf->points_size(); ++i) {
        pointArray[i] = [[TYTracePoint alloc] initWithPbf:pbf->mutable_points(i)];
    }
    
    return [[[self class] alloc] initWithTraceID:[NSString stringWithUTF8String:pbf->traceid().c_str()] Timestamp:pbf->timestamp() Points:pointArray];
}

@end
