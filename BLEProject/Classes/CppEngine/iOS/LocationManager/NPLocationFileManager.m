//
//  NPLocationFileManager.m
//  BLEProject
//
//  Created by innerpeacer on 15/4/13.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "NPLocationFileManager.h"

#define FILE_REGION_DB @"BeaconRegion.db"
#define FILE_BEACON_DB @"%@_Beacon.db"

@implementation NPLocationFileManager

+ (NSString *)getBeaconRegionDBPath
{
    NSString *rootDir = [TYMapEnvironment getRootDirectoryForMapFiles];
    return [rootDir stringByAppendingPathComponent:FILE_REGION_DB];
}

+ (NSString *)getBeaconDBPath:(TYBuilding *)building
{
    NSString *rootDir = [TYMapEnvironment getRootDirectoryForMapFiles];
    NSString *cityDir = [rootDir stringByAppendingPathComponent:building.cityID];
    NSString *buildingDir = [cityDir stringByAppendingPathComponent:building.buildingID];
    NSString *fileName = [NSString stringWithFormat:FILE_BEACON_DB, building.buildingID];
    return [buildingDir stringByAppendingPathComponent:fileName];
}

@end