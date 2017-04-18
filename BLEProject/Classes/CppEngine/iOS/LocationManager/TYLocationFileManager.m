//
//  TYLocationFileManager.m
//  BLEProject
//
//  Created by innerpeacer on 15/4/13.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYLocationFileManager.h"
#import "TYBLEEnvironment.h"

#define FILE_REGION_DB @"BeaconRegion.db"
#define FILE_BEACON_DB @"%@_Beacon.db"

@implementation TYLocationFileManager

+ (NSString *)getBeaconRegionDBPath
{
    NSString *rootDir = [TYBLEEnvironment getRootDirectoryForFiles];
    return [rootDir stringByAppendingPathComponent:FILE_REGION_DB];
}

+ (NSString *)getBeaconDBPath:(TYBuilding *)building
{
    NSString *rootDir = [TYBLEEnvironment getRootDirectoryForFiles];
    NSString *cityDir = [rootDir stringByAppendingPathComponent:building.cityID];
    NSString *buildingDir = [cityDir stringByAppendingPathComponent:building.buildingID];
    NSString *fileName = [NSString stringWithFormat:FILE_BEACON_DB, building.buildingID];
    return [buildingDir stringByAppendingPathComponent:fileName];
}

+ (NSString *)getBeaconDBPath:(NSString *)buildingID cityID:(NSString *)cityID
{
    NSString *rootDir = [TYBLEEnvironment getRootDirectoryForFiles];
    NSString *cityDir = [rootDir stringByAppendingPathComponent:cityID];
    NSString *buildingDir = [cityDir stringByAppendingPathComponent:buildingID];
    NSString *fileName = [NSString stringWithFormat:FILE_BEACON_DB, buildingID];
    return [buildingDir stringByAppendingPathComponent:fileName];
}

@end