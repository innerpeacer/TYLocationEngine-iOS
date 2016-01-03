#import "TYBeaconFMDBAdapter.h"
#import "IPXBeaconDBConstants.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "TYPointConverter.h"
#import "TYLocationFileManager.h"

@interface TYBeaconFMDBAdapter()
{
    FMDatabase *_database;
}

@end

@implementation TYBeaconFMDBAdapter

- (BOOL)open
{
    return [_database open];
}

- (BOOL)close
{
    return [_database close];
}

- (id)initWithBuilding:(TYBuilding *)building
{
    self = [super init];
    if (self) {
        NSString *dbPath = [TYLocationFileManager getBeaconDBPath:building];
        _database = [FMDatabase databaseWithPath:dbPath];
    }
    return self;
}

- (BOOL)deleteLocationingBeacon:(TYBeacon *)beacon
{
    return [self deleteLocationingBeaconWithMajor:beacon.major.intValue Minor:beacon.minor.intValue];
}

- (BOOL)deleteLocationingBeaconWithMajor:(int)major Minor:(int)minor
{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %d and %@ = %d ", TABLE_BEACON, FIELD_BEACON_2_MAJOR, major, FIELD_BEACON_3_MINOR, minor];
    return [_database executeUpdate:sql];
}

- (BOOL)eraseLocationingBeaconTable
{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_BEACON];
    return [_database executeUpdate:sql];
}



- (BOOL)insertLocationingBeacon:(TYPublicBeacon *)beacon
{
    return [self insertLocationingBeaconWithUUID:beacon.UUID Major:beacon.major Minor:beacon.minor X:beacon.location.x Y:beacon.location.y Z:0.0 Floor:beacon.location.floor ShopGid:beacon.shopGid];
}

- (BOOL)insertLocationingBeaconWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor X:(double)x Y:(double)y Z:(double)z Floor:(int)f ShopGid:(NSString *)shopid
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"Insert into %@", TABLE_BEACON];
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    
    NSString *fields = [NSString stringWithFormat:@" ( %@, %@, %@, %@, %@ , %@) ", FIELD_BEACON_O_GEOM, FIELD_BEACON_1_UUID, FIELD_BEACON_2_MAJOR, FIELD_BEACON_3_MINOR, FIELD_BEACON_4_FLOOR,FIELD_BEACON_5_SHOPID];
    NSString *values = @" ( ?, ?, ?, ?, ?, ?) ";
    
    [arguments addObject:[TYPointConverter dataFromX:x Y:y Z:z]];
    [arguments addObject:uuid];
    [arguments addObject:[NSString stringWithFormat:@"%d", major.intValue]];
    [arguments addObject:[NSString stringWithFormat:@"%d", minor.intValue]];
    [arguments addObject:[NSString stringWithFormat:@"%d", f]];
    [arguments addObject:shopid == nil ? [NSNull null] : shopid];

    [sql appendFormat:@" %@ VALUES %@", fields, values];
    return [_database executeUpdate:sql withArgumentsInArray:arguments];
}

- (BOOL)updateLocationingBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor X:(double)x Y:(double)y Z:(double)z Floor:(int)f ShopGid:(NSString *)shopid
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",TABLE_BEACON];
    NSString *fields = [NSString stringWithFormat:@" %@ = ?, %@ = ?, %@ = ?", FIELD_BEACON_O_GEOM, FIELD_BEACON_4_FLOOR, FIELD_BEACON_5_SHOPID];
    NSString *whereClause = [NSString stringWithFormat:@" where %@ = %d and %@ = %d ", FIELD_BEACON_2_MAJOR, major.intValue, FIELD_BEACON_3_MINOR, minor.intValue];

    [sql appendString:fields];
    [sql appendString:whereClause];
    
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    [arguments addObject:[TYPointConverter dataFromX:x Y:y Z:z]];
    [arguments addObject:[NSString stringWithFormat:@"%d", f]];
    [arguments addObject:shopid == nil ? [NSNull null] : shopid];
    
    return [_database executeUpdate:sql withArgumentsInArray:arguments];
}

- (BOOL)updateLocationingBeacon:(TYPublicBeacon *)beacon
{
    return [self updateLocationingBeaconWithMajor:beacon.major Minor:beacon.minor X:beacon.location.x Y:beacon.location.y Z:0.0 Floor:beacon.location.floor ShopGid:beacon.shopGid];
}

- (BOOL)updateLocationingBeacon:(TYBeacon *)beacon WithLocation:(TYLocalPoint *)lp ShopGid:(NSString *)shopID
{
    return [self updateLocationingBeaconWithMajor:beacon.major Minor:beacon.minor X:lp.x Y:lp.y Z:0.0 Floor:lp.floor ShopGid:shopID];
}

- (NSArray *)getAllLocationingBeacons
{
    NSString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@,%@,%@,%@,%@,%@,%@ FROM %@", FIELD_BEACON_O_GEOM, FIELD_BEACON_1_UUID, FIELD_BEACON_2_MAJOR, FIELD_BEACON_3_MINOR, FIELD_BEACON_4_FLOOR, FIELD_BEACON_5_SHOPID, FIELD_BEACON_6_TAG, TABLE_BEACON];
    
    FMResultSet *rs = [_database executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    while ([rs next]) {
        NSData *geoData = [rs dataForColumn:FIELD_BEACON_O_GEOM];
        NSString *uuid = [rs stringForColumn:FIELD_BEACON_1_UUID];
        double* xyz = [TYPointConverter xyzFromNSData:geoData];
        double x = xyz[0];
        double y = xyz[1];
        int major = [rs intForColumn:FIELD_BEACON_2_MAJOR];
        int minor = [rs intForColumn:FIELD_BEACON_3_MINOR];
        int floor = [rs intForColumn:FIELD_BEACON_4_FLOOR];
        NSString *tag = [rs stringForColumn:FIELD_BEACON_6_TAG];
        
        TYLocalPoint *location = [TYLocalPoint pointWithX:x Y:y Floor:floor];
        TYPublicBeacon *beacon = [TYPublicBeacon beaconWithUUID:uuid Major:@(major) Minor:@(minor) Tag:tag Location:location ShopGid:nil];
        [array addObject:beacon];
    }
    
    [rs close];
    return array;
}

- (TYPublicBeacon *)getLocationingBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@,%@,%@,%@ FROM %@", FIELD_BEACON_O_GEOM, FIELD_BEACON_1_UUID, FIELD_BEACON_4_FLOOR, FIELD_BEACON_5_SHOPID, TABLE_BEACON];
    NSString *whereClause = [NSString stringWithFormat:@" where %@ = %d and %@ = %d ",FIELD_BEACON_2_MAJOR, major.intValue, FIELD_BEACON_3_MINOR, minor.intValue];
    [sql appendString:whereClause];
    
    TYPublicBeacon *beacon = nil;
    FMResultSet * rs = [_database executeQuery:sql];
    if ([rs next]) {
        
        NSData *geoData = [rs dataForColumn:FIELD_BEACON_O_GEOM];
        NSString *uuid = [rs stringForColumn:FIELD_BEACON_1_UUID];

        double* xyz = [TYPointConverter xyzFromNSData:geoData];
        double x = xyz[0];
        double y = xyz[1];
        int floor = [rs intForColumn:FIELD_BEACON_4_FLOOR];
        TYLocalPoint *location;
        location = [TYLocalPoint pointWithX:x Y:y Floor:floor];
        
        NSString *shopId = [rs stringForColumn:FIELD_BEACON_5_SHOPID];
        beacon = [TYPublicBeacon beaconWithUUID:uuid Major:major Minor:minor Tag:nil Location:location ShopGid:shopId];
    }
    
    [rs close];
    return beacon;
}

#pragma mark CHECK_CODE
- (BOOL)eraseCheckCodeTable
{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_CODE];
    return [_database executeUpdate:sql];
}

- (BOOL)updateCheckCode:(NSString *)code
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",TABLE_CODE];
    NSString *fields = [NSString stringWithFormat:@" %@ = ? ", FIELD_CODE];
    
    [sql appendString:fields];
    
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    [arguments addObject:code == nil ? [NSNull null] : code];
    
    return [_database executeUpdate:sql withArgumentsInArray:arguments];
}

- (BOOL)insertCheckCode:(NSString *)code
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"Insert into %@", TABLE_CODE];
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    
    NSString *fields = [NSString stringWithFormat:@" ( %@ ) ", FIELD_CODE];
    NSString *values = @" ( ? ) ";
    
    [arguments addObject:code];
    
    [sql appendFormat:@" %@ VALUES %@", fields, values];
    return [_database executeUpdate:sql withArgumentsInArray:arguments];
}

- (NSString *)getCheckCode
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@ FROM %@", FIELD_CODE, TABLE_CODE];
    
    NSString *code = nil;
    FMResultSet * rs = [_database executeQuery:sql];
    if ([rs next]) {
        code = [rs stringForColumn:FIELD_CODE];
    }
    return code;
}

@end
