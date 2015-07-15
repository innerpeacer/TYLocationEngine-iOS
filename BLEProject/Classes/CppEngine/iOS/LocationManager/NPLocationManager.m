//
//  NPLocationManager.m
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "NPLocationManager.h"
#import "IPXLocationEngine.h"
#import "NPLocationFileManager.h"

#define CHECK_INTERVAL 1.0
#define DEFAULT_REQUEST_TIME_OUT 4.0

@interface NPLocationManager() <IPXLocationEngineDelegate>
{
    IPXLocationEngine *locationEngine;
    CLBeaconRegion *beaconRegion;
    
    NSString *beaconPath;
    NSDictionary *floorPathDictionary;
 
    TYLocalPoint *lastLocation;
    int lastFloor;
    
    NSDate *lastTimeLocationUpdated;
    NSTimer *locationCheckTimer;
}

@end

@implementation NPLocationManager

- (id)initWithBeaconDB:(NSString *)beaconDB FloorPathDict:(NSDictionary *)floorDict
{
    self = [super init];
    if (self) {
        beaconPath = beaconDB;
        floorPathDictionary = floorDict;
        locationEngine = [[IPXLocationEngine alloc] initEngineWithBeaconDBPath:beaconPath];
        locationEngine.delegate = self;
        _requestTimeOut = DEFAULT_REQUEST_TIME_OUT;
        lastFloor = 1;
    }
    return self;
}

- (id)initWithBuilding:(TYBuilding *)building
{
    return [[NPLocationManager alloc] initWithBeaconDB:[NPLocationFileManager getBeaconDBPath:building] FloorPathDict:nil];
}

- (void)setBeaconRegion:(CLBeaconRegion *)region
{
    beaconRegion = region;
    [locationEngine setBeaconRegion:region];
}

- (void)setLimitBeaconNumber:(BOOL)lbn
{
    [locationEngine setLimitBeaconNumber:lbn];
}

- (void)setMaxBeaconNumberForProcessing:(int)mbn
{
    [locationEngine setMaxBeaconNumberForProcessing:mbn];
}

- (void)setRssiThreshold:(int)threshold
{
    [locationEngine setRssiThreshold:threshold];
}

- (void)startUpdateLocation
{
    NSLog(@"startUpdateLocation");
    [locationEngine start];
    
    [locationCheckTimer invalidate];
    locationCheckTimer = [NSTimer scheduledTimerWithTimeInterval:CHECK_INTERVAL target:self selector:@selector(checkLocationUpdating) userInfo:nil repeats:YES];
    lastTimeLocationUpdated = [NSDate date];
}

- (void)stopUpdateLocation
{
    [locationEngine stop];
    
    [locationCheckTimer invalidate];
    locationCheckTimer = nil;
    lastTimeLocationUpdated = nil;
}

- (void)checkLocationUpdating
{
    if (ABS([lastTimeLocationUpdated timeIntervalSinceNow]) > _requestTimeOut) {
        if ([self.delegate respondsToSelector:@selector(NPLocationManagerdidFailUpdateLocation:)]) {
            [self.delegate NPLocationManagerdidFailUpdateLocation:self];
        }
    }
}

- (void)dealloc
{
    locationEngine.delegate = nil;
    
    [locationCheckTimer invalidate];
    locationCheckTimer = nil;
    
    lastTimeLocationUpdated = nil;
}

- (void)IPXLocationEngine:(IPXLocationEngine *)engine locationChanged:(TYLocalPoint *)newLocation
{
//    NSLog(@"locationChanged");
    lastTimeLocationUpdated = [NSDate date];
    
    if (newLocation.floor == 0) {
        if (lastLocation == nil) {
            newLocation.floor = 1;
        } else {
            newLocation.floor = lastLocation.floor;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(NPLocationManager:didUpdateLocation:)]) {
        [self.delegate NPLocationManager:self didUpdateLocation:newLocation];
    }
    
    lastLocation = newLocation;

}

- (void)IPXLocationEngine:(IPXLocationEngine *)engine headingChanged:(double)newHeading
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(NPLocationManager:didUpdateDeviceHeading:)]) {
        [self.delegate NPLocationManager:self didUpdateDeviceHeading:newHeading];
    }
}

- (TYLocalPoint *)getLastLocation
{
    return lastLocation;
}

@end