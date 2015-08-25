//
//  TYBeaconRegion.m
//  TYMapLocationDemo
//
//  Created by innerpeacer on 15/8/14.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYBeaconRegion.h"

@implementation TYBeaconRegion

- (NSString *)description
{
    return [NSString stringWithFormat:@"City: %@, BuildingID: %@, Name: %@, UUID: %@, Major: %d", _cityID, _buildingID, _name, _region.proximityUUID.UUIDString, _region.major.intValue];
}

@end
