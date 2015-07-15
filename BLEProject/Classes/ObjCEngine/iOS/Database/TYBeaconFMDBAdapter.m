#import "TYBeaconFMDBAdapter.h"
#import "TYBeaconFMDBConstants.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "TYPointConverter.h"
#import "AppConstants.h"
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

- (BOOL)deleteNephogramBeacon:(TYBeacon *)beacon
{
    return [self deleteNephogramBeaconWithMajor:beacon.major.intValue Minor:beacon.minor.intValue];
}

- (BOOL)deleteNephogramBeaconWithMajor:(int)major Minor:(int)minor
{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %d and %@ = %d ", TABLE_BEACON, FIELD_BEACON_MAJOR, major, FIELD_BEACON_MINOR, minor];
    return [_database executeUpdate:sql];
}

- (BOOL)eraseNephogramBeaconTable
{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_BEACON];
    return [_database executeUpdate:sql];
}

- (BOOL)insertNephogramBeacon:(TYPublicBeacon *)beacon
{
    return [self insertNephogramBeaconWithUUID:beacon.UUID Major:beacon.major Minor:beacon.minor X:beacon.location.x Y:beacon.location.y Z:0.0 Floor:beacon.location.floor ShopGid:beacon.shopGid];
}

- (BOOL)insertNephogramBeaconWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor X:(double)x Y:(double)y Z:(double)z Floor:(int)f ShopGid:(NSString *)shopid
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"Insert into %@", TABLE_BEACON];
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    
    NSString *fields = [NSString stringWithFormat:@" ( %@, %@, %@, %@, %@ , %@) ", FIELD_GEOM, FIELD_UUID, FIELD_BEACON_MAJOR, FIELD_BEACON_MINOR, FIELD_FLOOR,FIELD_NP_BEACON_SHOPID];
    NSString *values = @" ( ?, ?, ?, ?, ?, ?) ";
    
    [arguments addObject:[TYPointConverter dataFromX:x Y:y Z:z]];
    [arguments addObject:BEACON_SERVICE_UUID];
    [arguments addObject:[NSString stringWithFormat:@"%d", major.intValue]];
    [arguments addObject:[NSString stringWithFormat:@"%d", minor.intValue]];
    [arguments addObject:[NSString stringWithFormat:@"%d", f]];
    [arguments addObject:shopid == nil ? [NSNull null] : shopid];

    [sql appendFormat:@" %@ VALUES %@", fields, values];
    return [_database executeUpdate:sql withArgumentsInArray:arguments];
}

- (BOOL)updateNephogramBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor X:(double)x Y:(double)y Z:(double)z Floor:(int)f ShopGid:(NSString *)shopid
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",TABLE_BEACON];
    NSString *fields = [NSString stringWithFormat:@" %@ = ?, %@ = ?, %@ = ?", FIELD_GEOM, FIELD_FLOOR, FIELD_NP_BEACON_SHOPID];
    NSString *whereClause = [NSString stringWithFormat:@" where %@ = %d and %@ = %d ", FIELD_BEACON_MAJOR, major.intValue, FIELD_BEACON_MINOR, minor.intValue];

    [sql appendString:fields];
    [sql appendString:whereClause];
    
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    [arguments addObject:[TYPointConverter dataFromX:x Y:y Z:z]];
    [arguments addObject:[NSString stringWithFormat:@"%d", f]];
    [arguments addObject:shopid == nil ? [NSNull null] : shopid];
    
    return [_database executeUpdate:sql withArgumentsInArray:arguments];
}

- (BOOL)updateNephogramBeacon:(TYPublicBeacon *)beacon
{
    return [self updateNephogramBeaconWithMajor:beacon.major Minor:beacon.minor X:beacon.location.x Y:beacon.location.y Z:0.0 Floor:beacon.location.floor ShopGid:beacon.shopGid];
}

- (BOOL)updateNephogramBeacon:(TYBeacon *)beacon WithLocation:(TYLocalPoint *)lp ShopGid:(NSString *)shopID
{
    return [self updateNephogramBeaconWithMajor:beacon.major Minor:beacon.minor X:lp.x Y:lp.y Z:0.0 Floor:lp.floor ShopGid:shopID];
}

- (NSArray *)getAllNephogramBeacons
{
    NSString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@,%@,%@,%@,%@,%@,%@ FROM %@", FIELD_GEOM, FIELD_UUID, FIELD_BEACON_MAJOR, FIELD_BEACON_MINOR, FIELD_FLOOR, FIELD_NP_BEACON_SHOPID, FIELD_BEACON_TAG, TABLE_BEACON];
    
    FMResultSet *rs = [_database executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    while ([rs next]) {
        NSData *geoData = [rs dataForColumn:FIELD_GEOM];
        NSString *uuid = [rs stringForColumn:FIELD_UUID];
        double* xyz = [TYPointConverter xyzFromNSData:geoData];
        double x = xyz[0];
        double y = xyz[1];
        int major = [rs intForColumn:FIELD_BEACON_MAJOR];
        int minor = [rs intForColumn:FIELD_BEACON_MINOR];
        int floor = [rs intForColumn:FIELD_FLOOR];
        NSString *tag = [rs stringForColumn:FIELD_BEACON_TAG];
        
        TYLocalPoint *location = [TYLocalPoint pointWithX:x Y:y Floor:floor];
        TYPublicBeacon *beacon = [TYPublicBeacon beaconWithUUID:uuid Major:@(major) Minor:@(minor) Tag:tag Location:location ShopGid:nil];
        [array addObject:beacon];
        
    }
    
    [rs close];
    return array;

}

- (TYPublicBeacon *)getNephogramBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@,%@,%@,%@ FROM %@", FIELD_GEOM, FIELD_UUID, FIELD_FLOOR, FIELD_NP_BEACON_SHOPID, TABLE_BEACON];
    NSString *whereClause = [NSString stringWithFormat:@" where %@ = %d and %@ = %d ",FIELD_BEACON_MAJOR, major.intValue, FIELD_BEACON_MINOR, minor.intValue];
    [sql appendString:whereClause];
    
    TYPublicBeacon *beacon = nil;
    FMResultSet * rs = [_database executeQuery:sql];
    if ([rs next]) {
        
        NSData *geoData = [rs dataForColumn:FIELD_GEOM];
        NSString *uuid = [rs stringForColumn:FIELD_UUID];

        double* xyz = [TYPointConverter xyzFromNSData:geoData];
        double x = xyz[0];
        double y = xyz[1];
        int floor = [rs intForColumn:FIELD_FLOOR];
        TYLocalPoint *location;
        location = [TYLocalPoint pointWithX:x Y:y Floor:floor];
        
        NSString *shopId = [rs stringForColumn:FIELD_NP_BEACON_SHOPID];
        beacon = [TYPublicBeacon beaconWithUUID:uuid Major:major Minor:minor Tag:nil Location:location ShopGid:shopId];
    }
    
    [rs close];
    return beacon;
}

@end
