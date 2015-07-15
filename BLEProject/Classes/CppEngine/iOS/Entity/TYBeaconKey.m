//
//  BeaconKey.m
//  BLEProject
//
//  Created by innerpeacer on 15/2/4.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYBeaconKey.h"
#import "BLELocationEngineConstants.h"

@implementation TYBeaconKey

+ (NSNumber *)beaconKeyForCLBeacon:(CLBeacon *)beacon
{
    return @(beacon.major.intValue * CONSTANT_HUNDRED_THROUSAND + beacon.minor.intValue);
}

+ (NSNumber *)beaconKeyForTYBeacon:(TYBeacon *)beacon
{
    return @(beacon.major.intValue * CONSTANT_HUNDRED_THROUSAND + beacon.minor.intValue);
}

@end
