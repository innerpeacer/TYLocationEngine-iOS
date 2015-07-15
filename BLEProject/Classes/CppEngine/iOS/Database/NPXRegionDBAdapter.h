//
//  NPXRegionDBAdapter.h
//  BLEProject
//
//  Created by innerpeacer on 15/4/13.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NPXRegionDBAdapter : NSObject

- (id)initWithDBFile:(NSString *)path;

- (BOOL)open;
- (BOOL)close;

- (CLBeaconRegion *)getRegionForBuilding:(NSString *)buildingID;
- (NSString *)getBuildingIDForRegionWithUUID:(NSString *)uuid Major:(NSNumber *)major;
- (NSDictionary *)getAllBuildAndRegions;

@end
