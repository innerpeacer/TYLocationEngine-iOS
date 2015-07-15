//
//  TYLocationManager.h
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <TYMapData/TYMapData.h>
#import <TYMapSDK/TYMapSDK.h>

@class TYLocationManager;
@protocol TYLocationManagerDelegate <NSObject>

- (void)TYLocationManager:(TYLocationManager *)manager didUpdateLocation:(TYLocalPoint *)newLocation;
- (void)TYLocationManagerdidFailUpdateLocation:(TYLocationManager *)manager;
- (void)TYLocationManager:(TYLocationManager *)manager didUpdateDeviceHeading:(double)newHeading;
@end

@interface TYLocationManager : NSObject

- (id)initWithBuilding:(TYBuilding *)building;

- (void)startUpdateLocation;

- (void)stopUpdateLocation;

- (TYLocalPoint *)getLastLocation;

- (void)setBeaconRegion:(CLBeaconRegion *)region;
- (void)setLimitBeaconNumber:(BOOL)lbn;
- (void)setMaxBeaconNumberForProcessing:(int)mbn;
- (void)setRssiThreshold:(int)threshold;

@property (nonatomic, assign) float requestTimeOut;
@property (nonatomic, assign) id<TYLocationManagerDelegate> delegate;

@end
