//
//  CABeaconManager.h
//  BLEProject
//
//  Created by innerpeacer on 15/1/27.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class TYBeaconManager;

@protocol NPBeaconManagerDelegate <NSObject>

@required
- (void)beaconManager:(TYBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

@optional
- (void)beaconManager:(TYBeaconManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error;

- (void)beaconManagerNotAuthorized:(TYBeaconManager *)manager;

- (void)beaconManagerAuthorized:(TYBeaconManager *)manager;
@end

/**
 *  BLE Beacon管理
 */
@interface TYBeaconManager : NSObject

@property (nonatomic, weak) id<NPBeaconManagerDelegate> delegate;

- (void)startRanging:(CLBeaconRegion *)region;
- (void)stopRanging:(CLBeaconRegion *)region;

@end

