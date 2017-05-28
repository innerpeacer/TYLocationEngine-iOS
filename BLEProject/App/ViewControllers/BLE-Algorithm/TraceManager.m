//
//  TraceManager.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/7.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TraceManager.h"
#import "PbfDBRecord.h"
#import "PbfCollectionDatabase.h"

@implementation TraceManager

static NSDateFormatter *TraceDataFormatter;
static TYTrace *sharedTrace = nil;
+ (TYTrace *)currentTrace
{
    return sharedTrace;
}

+ (void)setCurrentTrace:(TYTrace *)trace
{
    sharedTrace = trace;
}

+ (TYTrace *)createNewTrace
{
    if (TraceDataFormatter == nil) {
        TraceDataFormatter = [[NSDateFormatter alloc] init];
        TraceDataFormatter.dateFormat = @"MMdd-HH:mm:ss";
    }
    NSDate *now = [NSDate date];
    NSString *traceID = [NSString stringWithFormat:@"Trace-%@", [TraceDataFormatter stringFromDate:now]];
    TYTrace *trace = [[TYTrace alloc] initWithTraceID:traceID Timestamp:[now timeIntervalSince1970]];
    return trace;
}

+ (TYTrace *)createPureTrace
{
    if (TraceDataFormatter == nil) {
        TraceDataFormatter = [[NSDateFormatter alloc] init];
        TraceDataFormatter.dateFormat = @"MMDD-HH:mm:ss";
    }
    NSDate *now = [NSDate date];
    NSString *traceID = [NSString stringWithFormat:@"TraceStep-%@", [TraceDataFormatter stringFromDate:now]];
    TYTrace *trace = [[TYTrace alloc] initWithTraceID:traceID Timestamp:[now timeIntervalSince1970]];
    return trace;
}

+ (void)saveTrace:(TYTrace *)trace
{
//    PbfDBRecord *record = [trace toPbfDBRecord];
//    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
//    [db open];
//    [db insertRecord:record];
//    [db close];
}

+ (void)deleteTrace:(NSString *)traceID
{
//    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
//    [db open];
//    [db deleteRecord:traceID];
//    [db close];
}

+ (void)deleteAllTraces
{
//    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
//    [db open];
//    [db deleteRecords:PBF_TRACE_DATA];
//    [db close];
}

+ (TYTrace *)getTrace:(NSString *)traceID
{
//    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
//    [db open];
//    PbfDBRecord *record = [db getRecord:traceID];
//    [db close];
//    return [TYTrace fromPbfDBRecord:record];
    return nil;
}

+ (NSArray *)getTraces
{
//    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
//    [db open];
//    NSArray *array = [db getRecords:PBF_TRACE_DATA];
//    [db close];
//    
//    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
//    for (int i = 0; i < array.count; ++i) {
//        PbfDBRecord *record = array[i];
//        [resultArray addObject:[TYTrace fromPbfDBRecord:record]];
//    }
//    return resultArray;
    return nil;
}

@end
