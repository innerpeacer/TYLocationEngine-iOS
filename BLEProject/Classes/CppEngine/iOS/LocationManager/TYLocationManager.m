//
//  TYLocationManager.m
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYLocationManager.h"
#import "IPXLocationEngine.h"
#import "TYLocationFileManager.h"

#define CHECK_INTERVAL 1.0
#define DEFAULT_REQUEST_TIME_OUT 4.0

@interface TYLocationManager() <IPXLocationEngineDelegate>
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

@implementation TYLocationManager

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
    NSString* invalidDateString = @"20171011";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate* invalidDate = [dateFormatter dateFromString:invalidDateString];
    NSTimeInterval interval = [invalidDate timeIntervalSinceDate:[NSDate date]];
    if (interval < 0) {
//        NSLog(@"抱歉，SDK已过期");
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误！" message:@"抱歉，定位引擎SDK已过期，请联系开发者。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        return nil;
    }
    
    return [[TYLocationManager alloc] initWithBeaconDB:[TYLocationFileManager getBeaconDBPath:building] FloorPathDict:nil];
}

- (void)setBeaconRegion:(CLBeaconRegion *)region
{
    beaconRegion = region;
    [locationEngine setBeaconRegion:region];
}

- (NSString *)generateRandomUUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(nil);
    CFStringRef uuidStringRef = CFUUIDCreateString(nil, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
    CFRelease(uuidStringRef);
//    NSLog(@"UUID: %@", uuid);
    return uuid;
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
//    NSLog(@"startUpdateLocation");
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
        if ([self.delegate respondsToSelector:@selector(TYLocationManagerdidFailUpdateLocation:)]) {
            [self.delegate TYLocationManagerdidFailUpdateLocation:self];
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
    
    if ([self.delegate respondsToSelector:@selector(TYLocationManager:didUpdateLocation:)]) {
        [self.delegate TYLocationManager:self didUpdateLocation:newLocation];
    }
    
    lastLocation = newLocation;
    
}

- (void)IPXLocationEngine:(IPXLocationEngine *)engine headingChanged:(double)newHeading
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TYLocationManager:didUpdateDeviceHeading:)]) {
        [self.delegate TYLocationManager:self didUpdateDeviceHeading:newHeading];
    }
}

- (void)IPXLocationEngine:(IPXLocationEngine *)engine didRangeBeacons:(NSArray *)beacons
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TYLocationManager:didRangedBeacons:)]) {
        [self.delegate TYLocationManager:self didRangedBeacons:beacons];
    }
}

- (void)IPXLocationEngine:(IPXLocationEngine *)engine didRangeLocationBeacons:(NSArray *)beacons
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TYLocationManager:didRangedLocationBeacons:)]) {
        [self.delegate TYLocationManager:self didRangedLocationBeacons:beacons];
    }
}

- (TYLocalPoint *)getLastLocation
{
    return lastLocation;
}

@end