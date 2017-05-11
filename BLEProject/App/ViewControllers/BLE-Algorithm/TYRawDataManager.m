//
//  TYRawDataManager.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/10.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYRawDataManager.h"
#import "PbfDBRecord.h"
#import "PbfCollectionDatabase.h"

@implementation TYRawDataManager

static NSDateFormatter *RawDataFormatter;
static TYRawDataCollection *sharedData = nil;

+ (TYRawDataCollection *)currentData
{
    return sharedData;
}

+ (void)setCurrentData:(TYRawDataCollection *)data
{
    sharedData = data;
}

+ (TYRawDataCollection *)createNewData
{
    if (RawDataFormatter == nil) {
        RawDataFormatter = [[NSDateFormatter alloc] init];
        RawDataFormatter.dateFormat = @"MMdd-HH:mm:ss";
    }
    
    NSString *dataID = [NSString stringWithFormat:@"RawData-%@", [RawDataFormatter stringFromDate:[NSDate date]]];
    TYRawDataCollection *data = [[TYRawDataCollection alloc] initWithDataID:dataID];
    return data;
}

+ (void)saveData:(TYRawDataCollection *)data
{
    PbfDBRecord *record = [data toPbfDBRecord];
    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
    [db open];
    [db insertRecord:record];
    [db close];
}

+ (void)deleteData:(NSString *)dataID
{
    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
    [db open];
    [db deleteRecord:dataID];
    [db close];
}

+ (void)deleteAllData
{
    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
    [db open];
    [db deleteRecords:PBF_RAW_DATA];
    [db close];
}

+ (TYRawDataCollection *)getData:(NSString *)dataID
{
    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
    [db open];
    PbfDBRecord *record = [db getRecord:dataID];
    [db close];
    return [TYRawDataCollection fromPbfDBRecord:record];
}

+ (NSArray *)getAllDataID
{
    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
    [db open];
    NSArray *array = [db getRecords:PBF_RAW_DATA];
    [db close];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; ++i) {
        PbfDBRecord *record = array[i];
        [resultArray addObject:record.dataID];
    }
    return resultArray;
}

+ (NSArray *)getAllData
{
    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
    [db open];
    NSArray *array = [db getRecords:PBF_RAW_DATA];
    [db close];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; ++i) {
        PbfDBRecord *record = array[i];
        [resultArray addObject:[TYRawDataCollection fromPbfDBRecord:record]];
    }
    return resultArray;
}

@end
