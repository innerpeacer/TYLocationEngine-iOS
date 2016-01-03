
#import "IPXBeaconDBAdapter.h"
#import <sqlite3.h>
#import "TYPointConverter.h"
#import "IPXBeaconDBConstants.h"

@interface IPXBeaconDBAdapter()
{
    sqlite3 *_database;
    NSString *_dbPath;
}

@end

@implementation IPXBeaconDBAdapter

- (BOOL)open
{
    if (sqlite3_open([_dbPath UTF8String], &_database) == SQLITE_OK) {
//        NSLog(@"db open success!");
        return YES;
    } else {
//        NSLog(@"db open failed!");
        return NO;
    }
}

- (BOOL)close
{
    return (sqlite3_close(_database) == SQLITE_OK);
}

- (id)initWithDBFile:(NSString *)path
{
    self = [super init];
    if (self) {
        _dbPath = path;
       
    }
    return self;
}

- (NSArray *)getAllLocationingBeacons
{
    NSMutableArray *array = [[NSMutableArray alloc] init];

     NSString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@,%@,%@,%@,%@,%@ FROM %@", FIELD_BEACON_O_GEOM, FIELD_BEACON_1_UUID, FIELD_BEACON_2_MAJOR, FIELD_BEACON_3_MINOR, FIELD_BEACON_4_FLOOR, FIELD_BEACON_5_SHOPID, TABLE_BEACON];
    const char *selectSql = [sql UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, selectSql, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSData *geoData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:sqlite3_column_bytes(statement, 0)];
            double* xyz = [TYPointConverter xyzFromNSData:geoData];
            double x = xyz[0];
            double y = xyz[1];
            
            NSString *uuid = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            
            int major = sqlite3_column_int(statement, 2);
            int minor = sqlite3_column_int(statement, 3);
            int floor = sqlite3_column_int(statement, 4);
            
            TYLocalPoint *location = [TYLocalPoint pointWithX:x Y:y Floor:floor];
            TYPublicBeacon *beacon = [TYPublicBeacon beaconWithUUID:uuid Major:@(major) Minor:@(minor) Tag:nil Location:location ShopGid:nil];
            [array addObject:beacon];
        }
    }
    sqlite3_finalize(statement);
    
    return array;
}

- (TYPublicBeacon *)getLocationingBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@,%@,%@,%@ FROM %@", FIELD_BEACON_O_GEOM, FIELD_BEACON_1_UUID, FIELD_BEACON_4_FLOOR, FIELD_BEACON_5_SHOPID, TABLE_BEACON];
    NSString *whereClause = [NSString stringWithFormat:@" where %@ = %d and %@ = %d ",FIELD_BEACON_2_MAJOR, major.intValue, FIELD_BEACON_3_MINOR, minor.intValue];
    [sql appendString:whereClause];
    
    const char *selectSql = [sql UTF8String];
    sqlite3_stmt *statement;

    TYPublicBeacon *beacon = nil;
    if (sqlite3_prepare_v2(_database, selectSql, -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            NSData *geoData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:sqlite3_column_bytes(statement, 0)];
            double* xyz = [TYPointConverter xyzFromNSData:geoData];
            double x = xyz[0];
            double y = xyz[1];
            
            NSString *uuid = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            
            int floor = sqlite3_column_int(statement, 2);
            
            TYLocalPoint *location = [TYLocalPoint pointWithX:x Y:y Floor:floor];
            beacon = [TYPublicBeacon beaconWithUUID:uuid Major:major Minor:minor Tag:nil Location:location ShopGid:nil];
        }
    }
    sqlite3_finalize(statement);
    
    return beacon;
}

- (NSString *)getCode
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@ FROM %@", FIELD_CODE, TABLE_CODE];
    const char *selectSql = [sql UTF8String];
    sqlite3_stmt *statement;
    
    NSString *code = nil;
    if (sqlite3_prepare_v2(_database, selectSql, -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            code = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0)  encoding:NSUTF8StringEncoding];
        }
    }
    sqlite3_finalize(statement);
    
    return code;
}

@end
