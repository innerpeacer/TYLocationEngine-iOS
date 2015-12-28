//
//  TYBeaconRegionDBAdapter.h
//  BLEProject
//
//  Created by innerpeacer on 15/12/24.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYBeaconRegion.h"

@interface TYBeaconRegionDBAdapter : NSObject

- (id)initWithPath:(NSString *)path;

- (BOOL)open;
- (BOOL)close;

- (BOOL)eraseBeaconRegionTable;
- (BOOL)insertBeaconRegion:(TYBeaconRegion *)region;
- (void)insertBeaconRegions:(NSArray *)regionArray;
- (BOOL)updateBeaconRegion:(TYBeaconRegion *)region;
//- (void)updateBeaconRegions:(NSArray *)regionArray;
- (BOOL)deleteBeaconRegion:(NSString *)buildingID;

- (NSArray *)getAllBeaconRegions;
- (TYBeaconRegion *)getBeaconRegion:(NSString *)buildingID;

@end
