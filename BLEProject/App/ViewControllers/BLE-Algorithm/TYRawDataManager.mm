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
#import "TYRawDataCollection+CppProtobuf.h"

#include "IPXPbfDBRecord.hpp"
#include "IPXPbfDBAdapter.hpp"

using namespace innerpeacer::rawdata;

@implementation TYRawDataManager

static NSDateFormatter *RawDataFormatter;
static TYRawDataCollection *sharedData = nil;

+ (NSString *)collectionDBPath
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"MyCollection.db"];
}

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
//    PbfDBRecord *record = [data toPbfDBRecord];
//    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
//    [db open];
//    [db insertRecord:record];
//    [db close];
    
    IPXPbfDBRecord *record = new IPXPbfDBRecord;
    [data toPbfRecord:record];

//    IPXPbfDBRecord record = [data toPbfRecord];
    IPXPbfDBAdapter db([[TYRawDataManager collectionDBPath] UTF8String]);
    db.open();
    db.insertRecord(record);
    db.close();
    
    delete record;
}

+ (void)deleteData:(NSString *)dataID
{
//    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
//    [db open];
//    [db deleteRecord:dataID];
//    [db close];

    IPXPbfDBAdapter db([[TYRawDataManager collectionDBPath] UTF8String]);
    db.open();
    db.deleteRecord([dataID UTF8String]);
    db.close();
}

+ (void)deleteAllData
{
//    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
//    [db open];
//    [db deleteRecords:PBF_RAW_DATA];
//    [db close];
    
    IPXPbfDBAdapter db([[TYRawDataManager collectionDBPath] UTF8String]);
    db.open();
    db.deleteRecords(IPX_PBF_RAW_DATA);
    db.close();
}

+ (TYRawDataCollection *)getData:(NSString *)dataID
{
//    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
//    [db open];
//    PbfDBRecord *record = [db getRecord:dataID];
//    [db close];
//    return [TYRawDataCollection fromPbfDBRecord:record];
    
    IPXPbfDBAdapter db([[TYRawDataManager collectionDBPath] UTF8String]);
    db.open();
    IPXPbfDBRecord *record = db.getRecord([dataID UTF8String]);
    db.close();
    
    TYRawDataCollection *result = [TYRawDataCollection fromCppPbfDBRecord:record];
    delete record;
    return result;
}

+ (NSArray *)getAllDataID
{
//    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
//    [db open];
//    NSArray *array = [db getRecords:PBF_RAW_DATA];
//    [db close];
//    
//    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
//    for (int i = 0; i < array.count; ++i) {
//        PbfDBRecord *record = array[i];
//        [resultArray addObject:record.dataID];
//    }
//    return resultArray;
    
    IPXPbfDBAdapter db([[TYRawDataManager collectionDBPath] UTF8String]);
    db.open();
    std::vector<IPXPbfDBRecord *> array = db.getRecords(IPX_PBF_RAW_DATA);
    db.close();
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.size(); ++i) {
        IPXPbfDBRecord *record = array.at(i);
        [resultArray addObject:[NSString stringWithUTF8String:record->dataID.c_str()]];
    }
    return resultArray;
}

+ (NSArray *)getAllData
{
//    PbfCollectionDatabase *db = [[PbfCollectionDatabase alloc] init];
//    [db open];
//    NSArray *array = [db getRecords:PBF_RAW_DATA];
//    [db close];
//    
//    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
//    for (int i = 0; i < array.count; ++i) {
//        PbfDBRecord *record = array[i];
//        [resultArray addObject:[TYRawDataCollection fromPbfDBRecord:record]];
//    }
//    return resultArray;
    
    IPXPbfDBAdapter db([[TYRawDataManager collectionDBPath] UTF8String]);
    db.open();
    std::vector<IPXPbfDBRecord *> array = db.getRecords(IPX_PBF_RAW_DATA);
    db.close();
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.size(); ++i) {
        IPXPbfDBRecord *record = array.at(i);
        [resultArray addObject:[TYRawDataCollection fromCppPbfDBRecord:record]];
    }
    return resultArray;
}

@end
