//
//  IPSyncBeaconDBAdapter.m
//  BLEProject
//
//  Created by innerpeacer on 16/1/3.
//  Copyright © 2016年 innerpeacer. All rights reserved.
//

#import "IPSyncBeaconDBAdapter.h"

#import "IPXBeaconDBConstants.h"
#import <sqlite3.h>
#import "TYPointConverter.h"

@interface IPSyncBeaconDBAdapter()
{
    sqlite3 *_database;
    NSString *_dbPath;
}

@end

@implementation IPSyncBeaconDBAdapter

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _dbPath = path;
    }
    return self;
}

- (BOOL)deleteLocatingBeacon:(TYBeacon *)beacon
{
    return [self deleteLocatingBeaconWithMajor:beacon.major.intValue Minor:beacon.minor.intValue];
}

- (BOOL)deleteLocatingBeaconWithMajor:(int)major Minor:(int)minor
{
    NSString *errorString = @"Error: failed to delete beacon";
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = ? and %@ = ? ", TABLE_BEACON, FIELD_BEACON_2_MAJOR, FIELD_BEACON_3_MINOR];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare(_database, [sql UTF8String], -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"%@", errorString);
        return NO;
    }
    
    sqlite3_bind_int(statement, 1, major);
    sqlite3_bind_int(statement, 2, minor);
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"%@", errorString);
        return NO;
    }
    return YES;
}
- (BOOL)eraseLocatingBeaconTable
{
    NSString *errorString = @"Error: failed to erase beacon Table";
    NSString *sql = [NSString stringWithFormat:@"delete from %@", TABLE_BEACON];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare(_database, [sql UTF8String], -1, &statement, NULL);
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

- (BOOL)insertLocatingBeacon:(TYPublicBeacon *)beacon
{
    NSString *errorString = @"Error: failed to insert beacon into the database.";
    NSString *sql = [NSString stringWithFormat:@"Insert into %@ (%@, %@, %@, %@, %@, %@, %@) values ( ?, ?, ?, ?, ?, ?, ?)", TABLE_BEACON, FIELD_BEACON_O_GEOM, FIELD_BEACON_1_UUID, FIELD_BEACON_2_MAJOR, FIELD_BEACON_3_MINOR, FIELD_BEACON_4_FLOOR, FIELD_BEACON_5_SHOPID, FIELD_BEACON_6_TAG];
    sqlite3_stmt *statement;
    int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"%@", errorString);
        return NO;
    }
    
    NSData *xyzData = [TYPointConverter dataFromX:beacon.location.x Y:beacon.location.y Z:0];
    sqlite3_bind_blob(statement, 1, (const void *)[xyzData bytes], (int)[xyzData length], SQLITE_STATIC);
    sqlite3_bind_text(statement, 2, [beacon.UUID UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_int(statement, 3, beacon.major.intValue);
    sqlite3_bind_int(statement, 4, beacon.minor.intValue);
    sqlite3_bind_int(statement, 5, beacon.location.floor);
    if (beacon.shopGid == nil) {
        sqlite3_bind_null(statement, 6);
    } else {
        sqlite3_bind_text(statement, 6, [beacon.shopGid UTF8String], -1, SQLITE_STATIC);
    }

    if (beacon.tag == nil) {
        sqlite3_bind_null(statement, 7);
    } else {
        sqlite3_bind_text(statement, 7, [beacon.tag UTF8String], -1, SQLITE_STATIC);
    }
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"%@", errorString);
        return NO;
    }
    return YES;
}

- (int)insertLocatingBeacons:(NSArray *)beaconArray
{
    int count = 0;
    sqlite3_exec(_database,"begin;",0,0,0);

    NSString *errorString = @"Error: failed to insert beacon into the database.";
    NSString *sql = [NSString stringWithFormat:@"Insert into %@ (%@, %@, %@, %@, %@, %@, %@) values ( ?, ?, ?, ?, ?, ?, ?)", TABLE_BEACON, FIELD_BEACON_O_GEOM, FIELD_BEACON_1_UUID, FIELD_BEACON_2_MAJOR, FIELD_BEACON_3_MINOR, FIELD_BEACON_4_FLOOR, FIELD_BEACON_5_SHOPID, FIELD_BEACON_6_TAG];
    sqlite3_stmt *statement;
    int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"%@", errorString);
        return 0;
    }
    
    for (TYPublicBeacon *beacon in beaconArray) {
        sqlite3_reset(statement);
        NSData *xyzData = [TYPointConverter dataFromX:beacon.location.x Y:beacon.location.y Z:0];
        sqlite3_bind_blob(statement, 1, (const void *)[xyzData bytes], (int)[xyzData length], SQLITE_STATIC);
        sqlite3_bind_text(statement, 2, [beacon.UUID UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_int(statement, 3, beacon.major.intValue);
        sqlite3_bind_int(statement, 4, beacon.minor.intValue);
        sqlite3_bind_int(statement, 5, beacon.location.floor);
        if (beacon.shopGid == nil) {
            sqlite3_bind_null(statement, 6);
        } else {
            sqlite3_bind_text(statement, 6, [beacon.shopGid UTF8String], -1, SQLITE_STATIC);
        }
        
        if (beacon.tag == nil) {
            sqlite3_bind_null(statement, 7);
        } else {
            sqlite3_bind_text(statement, 7, [beacon.tag UTF8String], -1, SQLITE_STATIC);
        }

        success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            NSLog(@"%@", errorString);
            return NO;
        }
    }
    sqlite3_finalize(statement);
    count =  sqlite3_exec(_database, "commit;",0,0,0);
    return count;
}

- (BOOL)updateLocatingBeacon:(TYPublicBeacon *)beacon
{
    return [self updateLocatingBeacon:beacon WithLocation:beacon.location ShopGid:beacon.shopGid];
}

- (BOOL)updateLocatingBeacon:(TYBeacon *)beacon WithLocation:(TYLocalPoint *)lp ShopGid:(NSString *)shopID
{
    NSString *errorString = @"Error: failed to update beacon";
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@=?, %@=?, %@=?, %@=?, %@=?, %@=?, %@=? where %@=? and %@=?", TABLE_BEACON, FIELD_BEACON_O_GEOM, FIELD_BEACON_1_UUID, FIELD_BEACON_2_MAJOR, FIELD_BEACON_3_MINOR, FIELD_BEACON_4_FLOOR, FIELD_BEACON_5_SHOPID, FIELD_BEACON_6_TAG, FIELD_BEACON_2_MAJOR, FIELD_BEACON_3_MINOR];
    //    NSLog(@"%@", sql);
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"%@", errorString);
        return NO;
    }
    
    NSData *xyzData = [TYPointConverter dataFromX:lp.x Y:lp.y Z:0];
    sqlite3_bind_blob(statement, 1, (const void *)[xyzData bytes], (int)[xyzData length], SQLITE_STATIC);
    sqlite3_bind_text(statement, 2, [beacon.UUID UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_int(statement, 3, beacon.major.intValue);
    sqlite3_bind_int(statement, 4, beacon.minor.intValue);
    sqlite3_bind_int(statement, 5, lp.floor);
    if (shopID == nil) {
        sqlite3_bind_null(statement, 6);
    } else {
        sqlite3_bind_text(statement, 6, [shopID UTF8String], -1, SQLITE_STATIC);
    }
    
    if (beacon.tag == nil) {
        sqlite3_bind_null(statement, 7);
    } else {
        sqlite3_bind_text(statement, 7, [beacon.tag UTF8String], -1, SQLITE_STATIC);
    }
    
    sqlite3_bind_int(statement, 8, beacon.major.intValue);
    sqlite3_bind_int(statement, 9, beacon.minor.intValue);
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"%@", errorString);
        return NO;
    }
    return YES;
}

- (NSArray *)getAllLocatingBeacons
{
    NSMutableArray *beaconArray = [NSMutableArray array];
    
    NSString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@,%@,%@,%@,%@,%@,%@ FROM %@", FIELD_BEACON_O_GEOM, FIELD_BEACON_1_UUID, FIELD_BEACON_2_MAJOR, FIELD_BEACON_3_MINOR, FIELD_BEACON_4_FLOOR, FIELD_BEACON_5_SHOPID, FIELD_BEACON_6_TAG, TABLE_BEACON];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSData *xyzData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:sqlite3_column_bytes(statement, 0)];
            double* xyz = [TYPointConverter xyzFromNSData:xyzData];
            double x = xyz[0];
            double y = xyz[1];
            NSString *uuid = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            int major = sqlite3_column_int(statement, 2);
            int minor = sqlite3_column_int(statement, 3);
            int floor = sqlite3_column_int(statement, 4);
            NSString *shopID = nil;
            if (sqlite3_column_type(statement, 5) != SQLITE_NULL) {
                shopID = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            }
            NSString *tag = nil;
            if (sqlite3_column_type(statement, 6) != SQLITE_NULL) {
                tag = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            }
            
            TYLocalPoint *location = [TYLocalPoint pointWithX:x Y:y Floor:floor];
            TYPublicBeacon *beacon = [TYPublicBeacon beaconWithUUID:uuid Major:@(major) Minor:@(minor) Tag:tag Location:location ShopGid:nil];
            [beaconArray addObject:beacon];
        }
    }
    sqlite3_finalize(statement);
    return beaconArray;
}
- (TYPublicBeacon *)getLocatingBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor
{
    TYPublicBeacon *beacon = nil;

    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@,%@,%@,%@ FROM %@", FIELD_BEACON_O_GEOM, FIELD_BEACON_1_UUID, FIELD_BEACON_4_FLOOR, FIELD_BEACON_5_SHOPID, TABLE_BEACON];
    NSString *whereClause = [NSString stringWithFormat:@" where %@ = %d and %@ = %d ",FIELD_BEACON_2_MAJOR, major.intValue, FIELD_BEACON_3_MINOR, minor.intValue];
    [sql appendString:whereClause];
    sqlite3_stmt *statement;

    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            NSData *xyzData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:sqlite3_column_bytes(statement, 0)];
            double* xyz = [TYPointConverter xyzFromNSData:xyzData];
            double x = xyz[0];
            double y = xyz[1];
            NSString *uuid = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            int major = sqlite3_column_int(statement, 2);
            int minor = sqlite3_column_int(statement, 3);
            int floor = sqlite3_column_int(statement, 4);
            NSString *shopID = nil;
            if (sqlite3_column_type(statement, 5) != SQLITE_NULL) {
                shopID = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            }
            NSString *tag = nil;
            if (sqlite3_column_type(statement, 6) != SQLITE_NULL) {
                tag = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            }
            
            TYLocalPoint *location = [TYLocalPoint pointWithX:x Y:y Floor:floor];

            beacon = [TYPublicBeacon beaconWithUUID:uuid Major:@(major) Minor:@(minor) Tag:tag Location:location ShopGid:nil];
        }
    }
    sqlite3_finalize(statement);
    return beacon;
}

- (BOOL)insertCheckCode:(NSString *)code
{
    NSString *errorString = @"Error: failed to insert checkcode into the database.";
    NSString *sql = [NSString stringWithFormat:@"Insert into %@ (%@) values (?)", TABLE_BEACON, FIELD_CODE];
    sqlite3_stmt *statement;
    int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"%@", errorString);
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [code UTF8String], -1, SQLITE_STATIC);
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"%@", errorString);
        return NO;
    }
    return YES;
}
- (BOOL)updateCheckCode:(NSString *)code
{
    NSString *errorString = @"Error: failed to update check code";
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET %@ = ? ",TABLE_CODE, FIELD_CODE];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"%@", errorString);
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [code UTF8String], -1, SQLITE_STATIC);
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"%@", errorString);
        return NO;
    }
    return YES;
}
- (BOOL)eraseCheckCodeTable
{
    NSString *errorString = @"Error: failed to erase check code Table";
    NSString *sql = [NSString stringWithFormat:@"delete from %@", TABLE_CODE];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare(_database, [sql UTF8String], -1, &statement, NULL);
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

- (NSString *)getCheckCode
{
    NSString *code = nil;
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@ FROM %@", FIELD_CODE, TABLE_CODE];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            if (sqlite3_column_type(statement, 0) != SQLITE_NULL) {
                code = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement,05) encoding:NSUTF8StringEncoding];
            }
        }
    }
    sqlite3_finalize(statement);
    return code;
}

- (BOOL)open
{
    if (sqlite3_open([_dbPath UTF8String], &_database) == SQLITE_OK) {
        //        NSLog(@"db open success!");
        [self createTablesIfNotExists];
        return YES;
    } else {
        //        NSLog(@"db open failed!");
        return NO;
    }
}

- (void)createTablesIfNotExists
{
    {
        NSString *beaconSql = [NSString stringWithFormat:@"create table if not exists %@ (%@, %@, %@, %@, %@, %@, %@) ", TABLE_BEACON,
                               [NSString stringWithFormat:@"%@ blob not null", FIELD_BEACON_O_GEOM],
                               [NSString stringWithFormat:@"%@ text not null", FIELD_BEACON_1_UUID],
                               [NSString stringWithFormat:@"%@ integer not null", FIELD_BEACON_2_MAJOR],
                               [NSString stringWithFormat:@"%@ integer not null", FIELD_BEACON_3_MINOR],
                               [NSString stringWithFormat:@"%@ integer not null", FIELD_BEACON_4_FLOOR],
                               [NSString stringWithFormat:@"%@ text", FIELD_BEACON_5_SHOPID],
                               [NSString stringWithFormat:@"%@ text", FIELD_BEACON_6_TAG] ];
        sqlite3_stmt *statement;
        NSInteger sqlReturn = sqlite3_prepare_v2(_database, [beaconSql UTF8String], -1, &statement, nil);
        if (sqlReturn != SQLITE_OK) {
            NSLog(@"create beacon table failed!");
            return;
        }
        sqlite3_step(statement);
        sqlite3_finalize(statement);
    }
    
    {
        NSString *codeSql = [NSString stringWithFormat:@"create table if not exists %@ (%@)", TABLE_CODE,
                                 [NSString stringWithFormat:@"%@ text", FIELD_CODE]];
        sqlite3_stmt *statement;
        NSInteger sqlReturn = sqlite3_prepare_v2(_database, [codeSql UTF8String], -1, &statement, nil);
        if (sqlReturn != SQLITE_OK) {
            NSLog(@"create code table failed!");
            return;
        }
        sqlite3_step(statement);
        sqlite3_finalize(statement);
    }
}

- (BOOL)close
{
    return (sqlite3_close(_database) == SQLITE_OK);
}

@end
