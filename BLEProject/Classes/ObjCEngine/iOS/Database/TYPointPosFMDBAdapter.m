//
//  TYPointPosFMDBAdapter.m
//  BLEProject
//
//  Created by innerpeacer on 15/12/1.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "TYPointPosFMDBAdapter.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "TYPointConverter.h"
#import "TYPointPosFMDBConstants.h"

@interface TYPointPosFMDBAdapter()
{
    FMDatabase *_database;
}

@end

@implementation TYPointPosFMDBAdapter

- (BOOL)open
{
    [self checkDatabase];
    return [_database open];
}

- (BOOL)close
{
    return [_database close];
}

- (NSString *)getPointPosDBPath:(TYBuilding *)building
{
    NSString *rootDir = [TYMapEnvironment getRootDirectoryForMapFiles];
    NSString *cityDir = [rootDir stringByAppendingPathComponent:building.cityID];
    NSString *buildingDir = [cityDir stringByAppendingPathComponent:building.buildingID];
    NSString *fileName = [NSString stringWithFormat:FILE_POINT_POS_DB, building.buildingID];
    return [buildingDir stringByAppendingPathComponent:fileName];
}

- (id)initWithBuilding:(TYBuilding *)building
{
    self = [super init];
    if (self) {
        NSString *dbPath = [self getPointPosDBPath:building];
        _database = [FMDatabase databaseWithPath:dbPath];
    }
    return self;
}

- (BOOL)deletePointPosition:(TYPointPosition *)position
{
    return [self deletePointPositionWithIndex:position.posIndex];
}

- (BOOL)deletePointPositionWithIndex:(int)index
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ where %@=%d", TABLE_POINT_POSITION, FIELD_BEACON_INDEX, index];
    return [_database executeUpdate:sql];
}

- (BOOL)erasePointPositionTable
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_POINT_POSITION];
    return [_database executeUpdate:sql];
}


- (BOOL)insertPointPosition:(TYPointPosition *)position
{
    return [self insertPointPositionWithX:position.location.x Y:position.location.y Floor:position.location.floor Index:position.posIndex];
}

- (BOOL)insertPointPositionWithX:(double)x Y:(double)y Floor:(int)floor Index:(int)index
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"Insert into %@", TABLE_POINT_POSITION];
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    
    NSString *fields = [NSString stringWithFormat:@" ( %@, %@, %@, %@, %@) ", FIELD_GEOM, FIELD_FLOOR, FIELD_BEACON_INDEX, FIELD_X, FIELD_Y];
    NSString *values = @" ( ?, ?, ?, ?, ?) ";
    
    [arguments addObject:[TYPointConverter dataFromX:x Y:y Z:0.0]];
    [arguments addObject:[NSString stringWithFormat:@"%d", floor]];
    [arguments addObject:[NSString stringWithFormat:@"%d", index]];
    [arguments addObject:[NSString stringWithFormat:@"%f", x]];
    [arguments addObject:[NSString stringWithFormat:@"%f", y]];

    [sql appendFormat:@" %@ VALUES %@", fields, values];
    return [_database executeUpdate:sql withArgumentsInArray:arguments];
}

- (BOOL)updatePointPositionWithX:(double)x Y:(double)y Floor:(int)floor Index:(int)index
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",TABLE_POINT_POSITION];
    NSString *fields = [NSString stringWithFormat:@" %@ = ?, %@ = ?", FIELD_GEOM, FIELD_FLOOR];
    NSString *whereClause = [NSString stringWithFormat:@" where %@ = %d ", FIELD_BEACON_INDEX, index];
    
    [sql appendString:fields];
    [sql appendString:whereClause];
    
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    [arguments addObject:[TYPointConverter dataFromX:x Y:y Z:0.0]];
    [arguments addObject:[NSString stringWithFormat:@"%d", floor]];
    [arguments addObject:[NSString stringWithFormat:@"%d", index]];
    [arguments addObject:[NSString stringWithFormat:@"%f", x]];
    [arguments addObject:[NSString stringWithFormat:@"%f", y]];
    
    return [_database executeUpdate:sql withArgumentsInArray:arguments];
}

- (BOOL)updatePointPosition:(TYPointPosition *)position
{
    return [self updatePointPositionWithX:position.location.x Y:position.location.y Floor:position.location.floor Index:position.posIndex];
}

- (NSArray *)getAllPointPositions
{
    NSString *sql = [NSMutableString stringWithFormat:@"select distinct %@,%@,%@ From %@", FIELD_GEOM, FIELD_FLOOR, FIELD_BEACON_INDEX, TABLE_POINT_POSITION];
    FMResultSet *rs = [_database executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([rs next]) {
        NSData *geoData = [rs dataForColumn:FIELD_GEOM];
        double* xyz = [TYPointConverter xyzFromNSData:geoData];
        double x = xyz[0];
        double y = xyz[1];
        int floor = [rs intForColumn:FIELD_FLOOR];
        int posIndex = [rs intForColumn:FIELD_BEACON_INDEX];
        
        TYLocalPoint *location = [TYLocalPoint pointWithX:x Y:y Floor:floor];
        TYPointPosition *pointPosition = [[TYPointPosition alloc] init];
        pointPosition.location = location;
        pointPosition.posIndex = posIndex;
        [array addObject:pointPosition];
    }
    [rs close];
    return array;
}

- (TYPointPosition *)getPointPositionWithIndex:(int)index
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT distinct %@,%@ FROM %@", FIELD_GEOM, FIELD_FLOOR, TABLE_POINT_POSITION];
    NSString *whereClause = [NSString stringWithFormat:@" where %@ = %d ", FIELD_BEACON_INDEX, index];
    [sql appendString:whereClause];
    
    TYPointPosition *pointPosition = nil;

    
    FMResultSet * rs = [_database executeQuery:sql];
    if ([rs next]) {
        NSData *geoData = [rs dataForColumn:FIELD_GEOM];
        double* xyz = [TYPointConverter xyzFromNSData:geoData];
        double x = xyz[0];
        double y = xyz[1];
        int floor = [rs intForColumn:FIELD_FLOOR];
        TYLocalPoint *location = [TYLocalPoint pointWithX:x Y:y Floor:floor];
        pointPosition = [[TYPointPosition alloc] init];
        pointPosition.location = location;
        pointPosition.posIndex = index;
    }
    [rs close];
    return pointPosition;
}

- (int)getMaxIndex
{
    int max = 0;
    NSString *sql = [NSString stringWithFormat:@"select max(posIndex) from %@", TABLE_POINT_POSITION];
    FMResultSet * rs = [_database executeQuery:sql];
    if ([rs next]) {
        max = [rs intForColumnIndex:0];
    }
    [rs close];
    return max;
}

- (void)checkDatabase
{
    [_database open];
    if (![self existTable:TABLE_POINT_POSITION]) {
        [self createPointPositionTable];
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
- (BOOL)createPointPositionTable
{
    {
        NSString *sql = [NSString stringWithFormat:@"create table %@ (%@)", TABLE_TEST_CODE, @"Code text"];
        [_database executeUpdate:sql];
    }
    
//    NSString *sql = [NSString stringWithFormat:@"create table %@ (%@, %@, %@, %@, %@, %@)", TABLE_POINT_POSITION, @"_id integer primary key autoincrement", @"geom blob not null", @"x real not null", @"y real not null", @"floor integer not null", @"posIndex integer not null"];
    NSString *sql = [NSString stringWithFormat:@"create table %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@)", TABLE_POINT_POSITION, @"_id integer primary key autoincrement", @"geom blob not null", @"uuid text", @"major integer", @"minor integer", @"floor integer not null", @"shop_id text", @"tag text", @"x real not null", @"y real not null", @"posIndex integer not null"];
    if ([_database executeUpdate:sql]) {
        return YES;
    } else {
        return NO;
    }
}


//#define FIELD_TEST_UUID @"uuid"
//#define FIELD_TEST_MAJOR @"major"
//#define FIELD_TEST_MINOR @"minor"
//#define FIELD_TEST_SHOP_ID @"shop_id"
//#define FIELD_TEST_TAG @"tag"

@end
