//
//  BeaconKey.h
//  BLEProject
//
//  Created by innerpeacer on 15/2/4.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYBeacon.h"
#import <CoreLocation/CoreLocation.h>

/**
 *  用于计算Beacon的Key
 */
@interface TYBeaconKey : NSObject

/**
 *  计算Beacon的Key
 *
 *  @param beacon Beacon
 *
 *  @return Beacon的Key
 */
+ (NSNumber *)beaconKeyForCLBeacon:(CLBeacon *)beacon;

/**
 *  计算Beacon的Key
 *
 *  @param beacon Beacon
 *
 *  @return Beacon的Key
 */
+ (NSNumber *)beaconKeyForTYBeacon:(TYBeacon *)beacon;

@end
