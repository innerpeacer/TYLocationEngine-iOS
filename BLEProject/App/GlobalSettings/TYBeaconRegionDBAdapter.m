//
//  TYBeaconRegionDBAdapter.m
//  BLEProject
//
//  Created by innerpeacer on 15/12/24.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "TYBeaconRegionDBAdapter.h"
#import "IPBeaconRegionDBConstants.h"

#import <sqlite3.h>
#import "TYBeaconRegion.h"

@interface TYBeaconRegionDBAdapter()
{
    sqlite3 *database;
    NSString *dbPath;
}

@end


@implementation TYBeaconRegionDBAdapter

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        dbPath = path;
    }
    return self;
}

- (BOOL)eraseBeaconRegionTable
{
    NSString *errorString = @"Error: failed to erase BeaconRegion Table";
    NSString *sql = [NSString stringWithFormat:@"delete from %@", TABLE_BEACON_REGION];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"%@", errorString);
        return NO;
    }
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"%@", errorString);
        return NO;
    }
    return YES;

}

- (NSArray *)getAllBeaconRegions
{
    NSMutableArray *regionArray = [[NSMutableArray alloc] init];
    
    NSString *sql = [NSMutableString stringWithFormat:@"select distinct %@,%@,%@,%@,%@ FROM %@", FIELD_BEACON_REGION_1_CITY_ID, FIELD_BEACON_REGION_2_BUILDING_ID, FIELD_BEACON_REGION_3_BUILDING_NAME, FIELD_BEACON_REGION_4_UUID, FIELD_BEACON_REGION_5_MAJOR, TABLE_BEACON_REGION];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *cityID = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            NSString *buildingID = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            NSString *name = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            NSString *uuidString = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            NSNumber *major = nil;
            if (sqlite3_column_type(statement, 4) != SQLITE_NULL) {
                major = @(sqlite3_column_int(statement, 4));
            }
            
            TYBeaconRegion *region = [TYBeaconRegion beaconRegionWithCityID:cityID BuildingID:buildingID Name:name UUID:uuidString Major:major];
            [regionArray addObject:region];
        }
    }
    sqlite3_finalize(statement);
    return regionArray;
}

- (TYBeaconRegion *)getBeaconRegion:(NSString *)buildingID
{
    TYBeaconRegion *region = nil;
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select distinct %@,%@,%@,%@,%@ FROM %@", FIELD_BEACON_REGION_1_CITY_ID, FIELD_BEACON_REGION_2_BUILDING_ID, FIELD_BEACON_REGION_3_BUILDING_NAME, FIELD_BEACON_REGION_4_UUID, FIELD_BEACON_REGION_5_MAJOR, TABLE_BEACON_REGION];
    [sql appendFormat:@" where %@='%@' ", FIELD_BEACON_REGION_2_BUILDING_ID, buildingID];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *cityID = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            NSString *buildingID = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            NSString *name = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            NSString *uuidString = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            NSNumber *major = nil;
            if (sqlite3_column_type(statement, 4) != SQLITE_NULL) {
                major = @(sqlite3_column_int(statement, 4));
            }
            
            region = [TYBeaconRegion beaconRegionWithCityID:cityID BuildingID:buildingID Name:name UUID:uuidString Major:major];
        }
    }
    sqlite3_finalize(statement);
    return region;
}

- (BOOL)insertBeaconRegion:(TYBeaconRegion *)region
{
    NSString *errorString = @"Error: failed to insert beaconRegion into the database.";
    NSString *sql = [NSString stringWithFormat:@"Insert into %@ (%@, %@, %@, %@, %@) values (?, ?, ?, ?, ?)", TABLE_BEACON_REGION, FIELD_BEACON_REGION_1_CITY_ID, FIELD_BEACON_REGION_2_BUILDING_ID, FIELD_BEACON_REGION_3_BUILDING_NAME, FIELD_BEACON_REGION_4_UUID, FIELD_BEACON_REGION_5_MAJOR];
    sqlite3_stmt *statement;
    int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"%@", errorString);
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [region.cityID UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(statement, 2, [region.buildingID UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(statement, 3, [region.name UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(statement, 4, [region.region.proximityUUID.UUIDString UTF8String], -1, SQLITE_STATIC);
    if (region.region.major == nil) {
        sqlite3_bind_null(statement, 5);
    } else {
        sqlite3_bind_int(statement, 5, region.region.major.intValue);
    }
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"%@", errorString);
        return NO;
    }
    return YES;
}

- (void)insertBeaconRegions:(NSArray *)regionArray
{
    for (TYBeaconRegion *region in regionArray) {
        [self insertBeaconRegion:region];
    }
}

- (BOOL)updateBeaconRegion:(TYBeaconRegion *)region
{
    NSString *errorString = @"Error: failed to update BeaconRegion";

    NSString *sql = [NSString stringWithFormat:@"update %@ set %@=?, %@=?, %@=?, %@=?, %@=? where %@=?", TABLE_BEACON_REGION, FIELD_BEACON_REGION_1_CITY_ID, FIELD_BEACON_REGION_2_BUILDING_ID, FIELD_BEACON_REGION_3_BUILDING_NAME, FIELD_BEACON_REGION_4_UUID, FIELD_BEACON_REGION_5_MAJOR, FIELD_BEACON_REGION_2_BUILDING_ID];
    //    NSLog(@"%@", sql);
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"%@", errorString);
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [region.cityID UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(statement, 2, [region.buildingID UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(statement, 3, [region.name UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(statement, 4, [region.region.proximityUUID.UUIDString UTF8String], -1, SQLITE_STATIC);
    if (region.region.major == nil) {
        sqlite3_bind_null(statement, 5);
    } else {
        sqlite3_bind_int(statement, 5, region.region.major.intValue);
    }
    sqlite3_bind_text(statement, 6, [region.buildingID UTF8String], -1, SQLITE_STATIC);

    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"%@", errorString);
        return NO;
    }
    return YES;
}

- (void)updateBeaconRegions:(NSArray *)regionArray
{
    for (TYBeaconRegion *region in regionArray) {
        [self updateBeaconRegion:region];
    }
}

- (BOOL)deleteBeaconRegion:(NSString *)buildingID
{
    NSString *errorString = @"Error: failed to delete BeaconRegion";
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = ?", TABLE_BEACON_REGION, FIELD_BEACON_REGION_2_BUILDING_ID];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"%@", errorString);
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [buildingID UTF8String], -1, SQLITE_STATIC);
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"%@", errorString);
        return NO;
    }
    return YES;
}

- (void)createTablesIfNotExists
{
    NSString *regionSql = [NSString stringWithFormat:@"create table if not exists %@ (%@, %@, %@, %@, %@, %@) ", TABLE_BEACON_REGION,
                           [NSString stringWithFormat:@"%@ integer primary key autoincrement", FIELD_BEACON_REGION_0_PRIMARY_KEY],
                           [NSString stringWithFormat:@"%@ text not null", FIELD_BEACON_REGION_1_CITY_ID],
                           [NSString stringWithFormat:@"%@ text not null", FIELD_BEACON_REGION_2_BUILDING_ID],
                           [NSString stringWithFormat:@"%@ text not null", FIELD_BEACON_REGION_3_BUILDING_NAME],
                           [NSString stringWithFormat:@"%@ text not null", FIELD_BEACON_REGION_4_UUID],
                           [NSString stringWithFormat:@"%@ integer", FIELD_BEACON_REGION_5_MAJOR]
                           ];
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(database, [regionSql UTF8String], -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        NSLog(@"create city table failed!");
        return;
    }
    sqlite3_step(statement);
    sqlite3_finalize(statement);
}

- (BOOL)open
{
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        //        NSLog(@"db open success!");
        [self createTablesIfNotExists];
        return YES;
    } else {
        //        NSLog(@"db open failed!");
        return NO;
    }
}

- (BOOL)close
{
    return (sqlite3_close(database) == SQLITE_OK);
}

@end
