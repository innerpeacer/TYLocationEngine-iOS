//
//  TYBeaconRegion.m
//  TYMapLocationDemo
//
//  Created by innerpeacer on 15/8/14.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYBeaconRegion.h"
#import "IPBeaconRegionDBConstants.h"

@implementation TYBeaconRegion

+ (TYBeaconRegion *)beaconRegionWithCityID:(NSString *)cid BuildingID:(NSString *)bid Name:(NSString *)name UUID:(NSString *)uuidString Major:(NSNumber *)m
{
    return [[TYBeaconRegion alloc] initWithCityID:cid BuildingID:bid Name:name UUID:uuidString Major:m];
}

- (id)initWithCityID:(NSString *)cid BuildingID:(NSString *)bid Name:(NSString *)name UUID:(NSString *)uuidString Major:(NSNumber *)m
{
    self = [super init];
    if (self) {
        _cityID = cid;
        _buildingID = bid;
        _name = name;
        
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
        CLBeaconRegion *beaconRegion;
        if (m) {
            beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[m intValue] identifier:name];
        } else {
            beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:name];
        }
        _region = beaconRegion;
    }
    return self;
}

+ (NSDictionary *)buildRegionObject:(TYBeaconRegion *)region
{
    NSMutableDictionary *regionObject = [NSMutableDictionary dictionary];
    
    [regionObject setObject:region.cityID forKey:FIELD_BEACON_REGION_1_CITY_ID];
    [regionObject setObject:region.buildingID forKey:FIELD_BEACON_REGION_2_BUILDING_ID];
    [regionObject setObject:region.name forKey:FIELD_BEACON_REGION_3_BUILDING_NAME];
    [regionObject setObject:region.region.proximityUUID.UUIDString forKey:FIELD_BEACON_REGION_4_UUID];
    if (region.region.major != nil) {
        [regionObject setObject:region.region.major forKey:FIELD_BEACON_REGION_5_MAJOR];
    }
    return regionObject;
}

+ (TYBeaconRegion *)parseBeaconRegionObject:(NSDictionary *)regionObject
{
    NSString *cityID = regionObject[FIELD_BEACON_REGION_1_CITY_ID];
    NSString *buildingID = regionObject[FIELD_BEACON_REGION_2_BUILDING_ID];
    NSString *name = regionObject[FIELD_BEACON_REGION_3_BUILDING_NAME];
    NSString *uuid = regionObject[FIELD_BEACON_REGION_4_UUID];
    NSNumber *major = regionObject[FIELD_BEACON_REGION_5_MAJOR];
    
    return [TYBeaconRegion beaconRegionWithCityID:cityID BuildingID:buildingID Name:name UUID:uuid Major:major];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"City: %@, BuildingID: %@, Name: %@, UUID: %@, Major: %@", _cityID, _buildingID, _name, _region.proximityUUID.UUIDString, _region.major];
}

@end
