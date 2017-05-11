//
//  PbfDBRecord.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/5.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "PbfDBRecord.h"
#import "TYTrace+Protobuf.h"
#import "TYRawDataCollection+Protobuf.h"

@implementation PbfDBRecord

@end

@implementation TYTrace(PbfDBRecord)

- (PbfDBRecord *)toPbfDBRecord
{
    PbfDBRecord *record = [[PbfDBRecord alloc] init];
    record.dataType = PBF_TRACE_DATA;
    record.dataID = self.traceID;
    record.pbfData = [self data];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY年MM月dd日 HH:mm:ss";
    record.dataDescription = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.timestamp]];
    return record;
}

+ (TYTrace *)fromPbfDBRecord:(PbfDBRecord *)record
{
    if (record == nil) {
        return nil;
    }
    return [TYTrace withData:record.pbfData error:nil];
}

@end

@implementation TYRawDataCollection(PbfDBRecord)

- (PbfDBRecord *)toPbfDBRecord
{
    PbfDBRecord *record = [[PbfDBRecord alloc] init];
    record.dataType = PBF_RAW_DATA;
    record.dataID = self.dataID;
    record.pbfData = [self data];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY年MM月dd日 HH:mm:ss";
    record.dataDescription = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.timestamp]];
    return record;
}

+ (TYRawDataCollection *)fromPbfDBRecord:(PbfDBRecord *)record
{
    if (record == nil) {
        return nil;
    }
    return [TYRawDataCollection withData:record.pbfData error:nil];
}

@end
