#import "TYPrimitiveBeaconDBAdapter.h"
#import "TYPrimitiveBeaconDBConstants.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface TYPrimitiveBeaconDBAdapter()
{
    FMDatabase *_database;
}

@end

@implementation TYPrimitiveBeaconDBAdapter

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
        NSString *dbPath = [TYMapFileManager getPrimitiveDBPath:building];
        _database = [FMDatabase databaseWithPath:dbPath];
        [self checkDatabase];
    }
    return self;
}

- (void)checkDatabase
{
    [_database open];
    if (![self existTable:TABLE_PRIMITIVE_BEACON]) {
        [self createPrimitiveTable];
    }
    
}

- (BOOL)existTable:(NSString *)table
{
    if (!table) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",table];
    
    FMResultSet *set = [_database executeQuery:sql];
    if([set next])
    {
        NSInteger count = [set intForColumnIndex:0];
        if (count > 0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

#pragma mark primitive beacon
- (BOOL)createPrimitiveTable
{
    NSString *sql = [NSString stringWithFormat:@"create table %@ (%@, %@, %@, %@)", TABLE_PRIMITIVE_BEACON, @"_id integer primary key autoincrement", @"major integer not null", @"minor integer not null", @"tag text not null"];
    if ([_database executeUpdate:sql]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)deletePrimitiveBeacon:(TYBeacon *)beacon
{
    return [self deletePrimitiveBeaconWithMajor:beacon.major Minor:beacon.minor];
}

- (BOOL)deletePrimitiveBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor
{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@' and %@ = '%@'", TABLE_PRIMITIVE_BEACON, FIELD_BEACON_MAJOR, [NSString stringWithFormat:@"%d", major.intValue], FIELD_BEACON_MINOR, [NSString stringWithFormat:@"%d", minor.intValue]];
    return [_database executeUpdate:sql];
}

- (BOOL)erasePrimitiveBeaconTable
{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_PRIMITIVE_BEACON];
    return [_database executeUpdate:sql];
}

- (BOOL)insertPrimitiveBeacon:(TYBeacon *)beacon
{
    return [self insertPrimitiveBeaconWithMajor:beacon.major Minor:beacon.minor Tag:beacon.tag];
}

- (BOOL)insertPrimitiveBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"Insert into %@", TABLE_PRIMITIVE_BEACON];
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    
    NSString *fields = [NSString stringWithFormat:@" ( %@, %@, %@) ", FIELD_BEACON_MAJOR, FIELD_BEACON_MINOR, FIELD_BEACON_TAG];
    NSString *values = @" ( ?, ?, ?) ";
    
    [arguments addObject:[NSString stringWithFormat:@"%d", major.intValue]];
    [arguments addObject:[NSString stringWithFormat:@"%d", minor.intValue]];
    [arguments addObject:tag];
    
    [sql appendFormat:@" %@ VALUES %@", fields, values];
    return [_database executeUpdate:sql withArgumentsInArray:arguments];
}

- (BOOL)updatePrimitiveBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",TABLE_PRIMITIVE_BEACON];
    NSString *fields = [NSString stringWithFormat:@" %@ = '%@'", FIELD_BEACON_TAG, tag];
    NSString *whereClause = [NSString stringWithFormat:@" where %@ = %d and %@ = %d ", FIELD_BEACON_MAJOR, major.intValue, FIELD_BEACON_MINOR, minor.intValue];
    
    [sql appendString:fields];
    [sql appendString:whereClause];
    
    return [_database executeUpdate:sql];
}

- (BOOL)updatePrimitiveBeacon:(TYBeacon *)beacon
{
    return [self updatePrimitiveBeaconWithMajor:beacon.major Minor:beacon.minor Tag:beacon.tag];
}

- (NSArray *)getAllPrimitiveBeacons
{
    NSString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@,%@,%@ FROM %@", FIELD_BEACON_MAJOR, FIELD_BEACON_MINOR, FIELD_BEACON_TAG, TABLE_PRIMITIVE_BEACON];
    
    FMResultSet * rs = [_database executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([rs next]) {
        NSNumber *major = [NSNumber numberWithInteger:[rs stringForColumn:FIELD_BEACON_MAJOR].integerValue];
        NSNumber *minor = [NSNumber numberWithInteger:[rs stringForColumn:FIELD_BEACON_MINOR].integerValue];
        NSString *tag = [rs stringForColumn:FIELD_BEACON_TAG];
        
        TYBeacon *beacon = [TYBeacon beaconWithUUID:nil Major:major Minor:minor Tag:tag];
        [array addObject:beacon];
    }
    
	[rs close];
    return array;
}

- (TYBeacon *)getPrimitiveBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@,%@,%@ FROM %@", FIELD_BEACON_MAJOR, FIELD_BEACON_MINOR, FIELD_BEACON_TAG, TABLE_PRIMITIVE_BEACON];
    
    NSString *whereClause = [NSString stringWithFormat:@" where %@ = %d and %@ = %d ",FIELD_BEACON_MAJOR, major.intValue, FIELD_BEACON_MINOR, minor.intValue];
    [sql appendString:whereClause];
    
    TYBeacon *beacon = nil;
    FMResultSet * rs = [_database executeQuery:sql];
    if ([rs next]) {
        NSNumber *major = [NSNumber numberWithInteger:[rs stringForColumn:FIELD_BEACON_MAJOR].integerValue];
        NSNumber *minor = [NSNumber numberWithInteger:[rs stringForColumn:FIELD_BEACON_MINOR].integerValue];
        NSString *tag = [rs stringForColumn:FIELD_BEACON_TAG];
        
        beacon = [TYBeacon beaconWithUUID:nil Major:major Minor:minor Tag:tag];
    }
    
	[rs close];
    return beacon;
}

- (TYBeacon *)getPrimitiveBeaconWithTag:(NSString *)tag
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@,%@,%@ FROM %@", FIELD_BEACON_MAJOR, FIELD_BEACON_MINOR, FIELD_BEACON_TAG, TABLE_PRIMITIVE_BEACON];
    
    NSString *whereClause = [NSString stringWithFormat:@" where %@ = '%@' ",FIELD_BEACON_TAG, tag];
    [sql appendString:whereClause];
    
    TYBeacon *beacon = nil;
    FMResultSet * rs = [_database executeQuery:sql];
    if ([rs next]) {
        NSNumber *major = [NSNumber numberWithInteger:[rs stringForColumn:FIELD_BEACON_MAJOR].integerValue];
        NSNumber *minor = [NSNumber numberWithInteger:[rs stringForColumn:FIELD_BEACON_MINOR].integerValue];
        NSString *tag = [rs stringForColumn:FIELD_BEACON_TAG];
        
        beacon = [TYBeacon beaconWithUUID:nil Major:major Minor:minor Tag:tag];
    }
    
	[rs close];
    return beacon;
}

@end
