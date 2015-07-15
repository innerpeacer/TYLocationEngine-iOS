//
//  IPXRegionDBAdapter.m
//  BLEProject
//
//  Created by innerpeacer on 15/4/13.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "IPXRegionDBAdapter.h"
#import "IPXRegionDBConstants.h"

#import <sqlite3.h>

@interface IPXRegionDBAdapter()
{
    sqlite3 *_database;
    NSString *_dbPath;
}
@end

@implementation IPXRegionDBAdapter

- (id)initWithDBFile:(NSString *)path
{
    self = [super init];
    if (self) {
        _dbPath = path;
    }
    return self;
}

- (BOOL)open
{
    if (sqlite3_open([_dbPath UTF8String], &_database) == SQLITE_OK) {
        NSLog(@"db open success!");
        return YES;
    } else {
        NSLog(@"db open failed!");
        return NO;
    }
}

- (BOOL)close
{
    return (sqlite3_close(_database) == SQLITE_OK);
}

- (CLBeaconRegion *)getRegionForBuilding:(NSString *)buildingID
{
    CLBeaconRegion *result = nil;
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select distinct %@, %@ from %@", FIELD_REGION_UUID, FIELD_REGION_MAJOR, TABLE_LOCATION_REGION];
    NSString *whereClause = [NSString stringWithFormat:@" where %@ = '%@' ", FIELD_REGION_BUILDING_ID, buildingID];
    [sql appendString:whereClause];
        
    const char *selectSql = [sql UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, selectSql, -1, &statement, nil) == SQLITE_OK) {
        int step;
        if ((step = sqlite3_step(statement)) == SQLITE_ROW) {
            NSString *uuidString = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
            int major = sqlite3_column_int(statement, 1);
            result = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:major identifier:REGION_IDENTIFIER];
        }
    }
    sqlite3_finalize(statement);

    return result;
}

- (NSString *)getBuildingIDForRegionWithUUID:(NSString *)uuid Major:(NSNumber *)major
{
    NSString *buildingID = nil;
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select distinct %@ from %@", FIELD_REGION_BUILDING_ID, TABLE_LOCATION_REGION];
    NSString *whereClause = [NSString stringWithFormat:@" where %@ = '%@' and %@ = %@", FIELD_REGION_UUID, uuid, FIELD_REGION_MAJOR, major];
    [sql appendString:whereClause];
        
    const char *selectSql = [sql UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, selectSql, -1, &statement, nil) ==  SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            buildingID = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
        }
    }
    sqlite3_finalize(statement);

    return buildingID;
}

- (NSDictionary *)getAllBuildAndRegions
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select distinct %@, %@, %@ from %@", FIELD_REGION_BUILDING_ID, FIELD_REGION_UUID, FIELD_REGION_MAJOR, TABLE_LOCATION_REGION];
    
    const char *selectSql = [sql UTF8String];
    sqlite3_stmt *statement;

    if (sqlite3_prepare_v2(_database, selectSql, -1, &statement, nil) ==  SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *buildingID = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            NSString *uuidString = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
            int major = sqlite3_column_int(statement, 2);
            
            CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:major identifier:REGION_IDENTIFIER];
            [dict setObject:region forKey:buildingID];
        }
    }
    sqlite3_finalize(statement);
    
    return dict;
}

@end
