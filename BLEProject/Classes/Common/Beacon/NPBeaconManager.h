//
//  CABeaconManager.h
//  CloudAtlasTestProject
//
//  Created by innerpeacer on 15/1/27.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class NPBeaconManager;

@protocol NPBeaconManagerDelegate <NSObject>

@required
- (void)beaconManager:(NPBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

@optional
- (void)beaconManager:(NPBeaconManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error;

- (void)beaconManagerNotAuthorized:(NPBeaconManager *)manager;

- (void)beaconManagerAuthorized:(NPBeaconManager *)manager;
@end

/**
 *  CloudAtlas Beacon管理
 */
@interface NPBeaconManager : NSObject

@property (nonatomic, weak) id<NPBeaconManagerDelegate> delegate;

- (void)startRanging:(CLBeaconRegion *)region;
- (void)stopRanging:(CLBeaconRegion *)region;

@end

