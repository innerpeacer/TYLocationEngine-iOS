//
//  BeaconKey.h
//  BLEProject
//
//  Created by innerpeacer on 15/2/4.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPBeacon.h"
#import <CoreLocation/CoreLocation.h>

@interface NPBeaconKey : NSObject

+ (NSNumber *)beaconKeyForCLBeacon:(CLBeacon *)beacon;
+ (NSNumber *)beaconKeyForNPBeacon:(NPBeacon *)beacon;

@end
