//
//  TYBuildingMonitor.m
//  BLEProject
//
//  Created by innerpeacer on 15/4/13.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYBuildingMonitor.h"
#import "TYBeaconManager.h"
#import "TYLocationFileManager.h"
#import "IPXRegionDBAdapter.h"
#import "TYRegionManager.h"

#import "TYLocationManager.h"
#import "TYUserDefaults.h"

@interface TYBuildingMonitor() <TYBeaconManagerDelegate>
{
    TYBeaconManager *beaconManager;
    NSDictionary *beaconRegionDict;
    BOOL isMonitoring;
}

@end

@implementation TYBuildingMonitor

- (id)initMonitor
{
    self = [super init];
    if (self) {
        NSLog(@"TYBuildingMonitor initMonitor");
        
        beaconManager = [[TYBeaconManager alloc] init];
        beaconManager.delegate = self;
        
        IPXRegionDBAdapter *regionDBAdapter = [[IPXRegionDBAdapter alloc] initWithDBFile:[TYLocationFileManager getBeaconRegionDBPath]];
        [regionDBAdapter open];
        beaconRegionDict = [regionDBAdapter getAllBuildAndRegions];
        [regionDBAdapter close];
        
        isMonitoring = NO;
    }
    return self;
}

- (void)start
{
    if (isMonitoring) {
        return;
    }
    
    isMonitoring = YES;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E2879308-4FA3-4F30-AC22-19ECDCB0D8C8"];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:12345 identifier:@"Test"];
    [beaconManager startRanging:region];
    beaconManager.delegate = self;
}

- (void)stop
{
    if (!isMonitoring) {
        return;
    }
    
    isMonitoring = NO;
}

- (void)beaconManager:(TYBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"beaconManager:didRangeBeacons: %d", (int)beacons.count);
}

- (TYBuilding *)getCurrentBuilding
{
    return nil;
}

@end
