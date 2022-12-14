//
//  IPXLocationEngine.h
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <TYMapData/TYMapData.h>

@class IPXLocationEngine;
@protocol IPXLocationEngineDelegate <NSObject>

@optional
- (void)IPXLocationEngine:(IPXLocationEngine *)engine didRangeBeacons:(NSArray *)beacons;
- (void)IPXLocationEngine:(IPXLocationEngine *)engine didRangeLocationBeacons:(NSArray *)beacons;

- (void)IPXLocationEngine:(IPXLocationEngine *)engine immediateLocationChanged:(TYLocalPoint *)immediateLocation;
@optional
- (void)IPXLocationEngine:(IPXLocationEngine *)engine locationChanged:(TYLocalPoint *)newLocation;
- (void)IPXLocationEngine:(IPXLocationEngine *)engine headingChanged:(double)newHeading;
@end


@interface IPXLocationEngine : NSObject

- (id)initEngineWithBeaconDBPath:(NSString *)beaconDBPath;

- (void)setBeaconRegion:(CLBeaconRegion *)region;
- (void)setLimitBeaconNumber:(BOOL)lbn;
- (void)setMaxBeaconNumberForProcessing:(int)mbn;

- (void)start;
- (void)stop;

- (void)setRssiThreshold:(int)threshold;

@property (nonatomic, assign) id<IPXLocationEngineDelegate> delegate;

@end
