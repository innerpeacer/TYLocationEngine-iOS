
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

- (id)initWithDBFile:(NSString *)path
{
    self = [super init];
    if (self) {
        _dbPath = path;
       
    }
    return self;
}

- (NSArray *)getAllNephogramBeacons
{
    NSMutableArray *array = [[NSMutableArray alloc] init];

     NSString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@,%@,%@,%@,%@,%@ FROM %@", FIELD_GEOM, FIELD_UUID, FIELD_BEACON_MAJOR, FIELD_BEACON_MINOR, FIELD_FLOOR, FIELD_TY_BEACON_SHOPID, TABLE_BEACON];
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

- (TYPublicBeacon *)getNephogramBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@,%@,%@,%@ FROM %@", FIELD_GEOM, FIELD_UUID, FIELD_FLOOR, FIELD_TY_BEACON_SHOPID, TABLE_BEACON];
    NSString *whereClause = [NSString stringWithFormat:@" where %@ = %d and %@ = %d ",FIELD_BEACON_MAJOR, major.intValue, FIELD_BEACON_MINOR, minor.intValue];
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
@end
