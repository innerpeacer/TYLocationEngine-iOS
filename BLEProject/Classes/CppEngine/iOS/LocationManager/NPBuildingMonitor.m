//
//  NPBuildingMonitor.m
//  CloudAtlasTestProject
//
//  Created by innerpeacer on 15/4/13.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "NPBuildingMonitor.h"
#import "NPBeaconManager.h"
#import "NPLocationFileManager.h"
#import "NPXRegionDBAdapter.h"
#import "TYRegionManager.h"


#import "NPLocationManager.h"
#import "TYUserDefaults.h"

@interface NPBuildingMonitor() <NPBeaconManagerDelegate>
{
    NPBeaconManager *beaconManager;
    NSDictionary *beaconRegionDict;
    BOOL isMonitoring;
}

@end

@implementation NPBuildingMonitor

- (id)initMonitor
{
    self = [super init];
    if (self) {
        NSLog(@"NPBuildingMonitor initMonitor");
        
        beaconManager = [[NPBeaconManager alloc] init];
        beaconManager.delegate = self;
        
        NPXRegionDBAdapter *regionDBAdapter = [[NPXRegionDBAdapter alloc] initWithDBFile:[NPLocationFileManager getBeaconRegionDBPath]];
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

- (void)beaconManager:(NPBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"beaconManager:didRangeBeacons: %d", (int)beacons.count);
}

- (TYBuilding *)getCurrentBuilding
{
    return nil;
}

@end
