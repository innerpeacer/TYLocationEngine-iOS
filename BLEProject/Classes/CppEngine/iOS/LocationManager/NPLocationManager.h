//
//  NPLocationManager.h
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <TYMapData/TYMapData.h>
#import <TYMapSDK/TYMapSDK.h>

@class NPLocationManager;
@protocol NPLocationManagerDelegate <NSObject>

- (void)NPLocationManager:(NPLocationManager *)manager didUpdateLocation:(TYLocalPoint *)newLocation;
- (void)NPLocationManagerdidFailUpdateLocation:(NPLocationManager *)manager;
- (void)NPLocationManager:(NPLocationManager *)manager didUpdateDeviceHeading:(double)newHeading;
@end

@interface NPLocationManager : NSObject

- (id)initWithBuilding:(TYBuilding *)building;

- (void)startUpdateLocation;

- (void)stopUpdateLocation;

- (TYLocalPoint *)getLastLocation;

- (void)setBeaconRegion:(CLBeaconRegion *)region;
- (void)setLimitBeaconNumber:(BOOL)lbn;
- (void)setMaxBeaconNumberForProcessing:(int)mbn;
- (void)setRssiThreshold:(int)threshold;

@property (nonatomic, assign) float requestTimeOut;
@property (nonatomic, assign) id<NPLocationManagerDelegate> delegate;

@end
