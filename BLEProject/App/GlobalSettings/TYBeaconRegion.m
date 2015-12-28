//
//  TYBeaconRegion.m
//  TYMapLocationDemo
//
//  Created by innerpeacer on 15/8/14.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYBeaconRegion.h"

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

- (NSString *)description
{
    return [NSString stringWithFormat:@"City: %@, BuildingID: %@, Name: %@, UUID: %@, Major: %@", _cityID, _buildingID, _name, _region.proximityUUID.UUIDString, _region.major];
}

@end
