//
//  PbfDBRecord.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/5.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "PbfDBRecord.h"
#import "TYTrace+Protobuf.h"

@implementation PbfDBRecord

@end

@implementation TYTrace(PbfDBRecord)

- (PbfDBRecord *)toPbfDBRecord
{
    PbfDBRecord *record = [[PbfDBRecord alloc] init];
    record.dataType = PBF_TRACE_DATA;
    record.dataID = self.traceID;
    record.pbfData = [self data];
    record.dataDescription = [NSString stringWithFormat:@"%f", self.timestamp];
    return record;
}

+ (TYTrace *)fromPbfDBRecord:(PbfDBRecord *)record
{
    if (record == nil) {
        return nil;
    }

    return [TYTrace traceWithData:record.pbfData error:nil];
}

@end
