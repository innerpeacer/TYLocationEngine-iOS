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

#import "TYTrace+CppProtobuf.h"

#include "IPXPbfDBRecord.hpp"
#include "IPXPbfDBAdapter.hpp"

using namespace innerpeacer::rawdata;

@implementation TraceManager

static NSDateFormatter *TraceDataFormatter;
static TYTrace *sharedTrace = nil;

+ (NSString *)collectionDBPath
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"MyCollection.db"];
}

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
    IPXPbfDBRecord *record = new IPXPbfDBRecord();
    [trace toPbfRecord:record];
    
    IPXPbfDBAdapter db([[TraceManager collectionDBPath] UTF8String]);
    db.open();
    db.insertRecord(record);
    db.close();
    
    delete record;
}

+ (void)deleteTrace:(NSString *)traceID
{
    IPXPbfDBAdapter db([[TraceManager collectionDBPath] UTF8String]);
    db.open();
    db.deleteRecord([traceID UTF8String]);
    db.close();
}

+ (void)deleteAllTraces
{
    IPXPbfDBAdapter db([[TraceManager collectionDBPath] UTF8String]);
    db.open();
    db.deleteRecords(IPX_PBF_TRACE_DATA);
    db.close();
}

+ (TYTrace *)getTrace:(NSString *)traceID
{
    IPXPbfDBAdapter db([[TraceManager collectionDBPath] UTF8String]);
    db.open();
    IPXPbfDBRecord *record = db.getRecord([traceID UTF8String]);
    db.close();
    
    TYTrace *result = [TYTrace fromCppPbfDBRecord:record];
    delete record;
    return result;
}

+ (NSArray *)getTraces
{
    IPXPbfDBAdapter db([[TraceManager collectionDBPath] UTF8String]);
    db.open();
    std::vector<IPXPbfDBRecord *> array = db.getRecords(IPX_PBF_TRACE_DATA);
    db.close();
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.size(); ++i) {
        IPXPbfDBRecord *record = array.at(i);
        [resultArray addObject:[TYTrace fromCppPbfDBRecord:record]];
    }
    
    for (int i = 0; i < array.size(); ++i) {
        delete array.at(i);
    }
    return resultArray;
}

@end
