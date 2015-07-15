//
//  CABeaconManager.m
//  BLEProject
//
//  Created by innerpeacer on 15/1/27.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYBeaconManager.h"

@interface TYBeaconManager() <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    
}

@end

@implementation TYBeaconManager

- (id)init
{
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [locationManager requestAlwaysAuthorization];
        }
    }
    return self;
}

- (void)startRanging:(CLBeaconRegion *)region
{
    if (![CLLocationManager isRangingAvailable]) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(beaconManagerNotAuthorized:)])
        {
            [self.delegate beaconManagerNotAuthorized:self];
        }
        return;
    }
    [locationManager startRangingBeaconsInRegion:region];
}

- (void)stopRanging:(CLBeaconRegion *)region
{
    [locationManager stopRangingBeaconsInRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
//    NSLog(@"didRangeBeacons");
    if (self.delegate && [self.delegate respondsToSelector:@selector(beaconManager:didRangeBeacons:inRegion:)]) {
        [self.delegate beaconManager:self didRangeBeacons:beacons inRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(beaconManager:rangingBeaconsDidFailForRegion:withError:)]) {
        [self.delegate beaconManager:self rangingBeaconsDidFailForRegion:region withError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"kCLAuthorizationStatusNotDetermined");
            if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [locationManager requestAlwaysAuthorization];
            }
            break;
        
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
            if (self.delegate && [self.delegate respondsToSelector:@selector(beaconManagerAuthorized:)]) {
                [self.delegate beaconManagerAuthorized:self];
            }
            break;

        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"kCLAuthorizationStatusAuthorizedAlways");
            if (self.delegate && [self.delegate respondsToSelector:@selector(beaconManagerAuthorized:)]) {
                [self.delegate beaconManagerAuthorized:self];
            }
            break;
            
//        case kCLAuthorizationStatusAuthorized:
//            NSLog(@"kCLAuthorizationStatusAuthorized");
//            if (self.delegate && [self.delegate respondsToSelector:@selector(beaconManagerAuthorized:)]) {
//                [self.delegate beaconManagerAuthorized:self];
//            }
//            break;

        case kCLAuthorizationStatusDenied:
            
            break;
            
        default:
            if (self.delegate && [self.delegate respondsToSelector:@selector(beaconManagerNotAuthorized:)]) {
                [self.delegate beaconManagerNotAuthorized:self];
            }
            break;
    }
}

@end
