//
//  LocationTestHelper.h
//  BLEProject
//
//  Created by innerpeacer on 2017/4/20.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TYMapSDK/TYMapSDK.h>

@interface LocationTestHelper : NSObject
+ (void)encodeBeaconArrayToJson:(NSArray *)array;
+ (void)encodeBeaconJsonForServer:(NSArray *)array Building:(TYBuilding *)building MapInfos:(NSArray *)mapInfoArray;

+ (void)showBeaconLocationsWithMapInfo:(TYMapInfo *)mapInfo Building:(TYBuilding *)building OnLayer:(AGSGraphicsLayer *)layer;
+ (void)showHintRssiForLocationBeacons:(NSArray *)beacons WithMapInfo:(TYMapInfo *)mapInfo OnLayer:(AGSGraphicsLayer *)layer;

@end
