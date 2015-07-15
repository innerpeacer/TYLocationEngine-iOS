//
//  NPXLocationEngine.h
//  CloudAtlasTestProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <TYMapData/TYMapData.h>

@class NPXLocationEngine;
@protocol NPXLocationEngineDelegate <NSObject>

@optional
- (void)NPXLocationEngine:(NPXLocationEngine *)engine locationChanged:(TYLocalPoint *)newLocation;
- (void)NPXLocationEngine:(NPXLocationEngine *)engine headingChanged:(double)newHeading;
@end


@interface NPXLocationEngine : NSObject

- (id)initEngineWithBeaconDBPath:(NSString *)beaconDBPath;

- (void)setBeaconRegion:(CLBeaconRegion *)region;
- (void)setLimitBeaconNumber:(BOOL)lbn;
- (void)setMaxBeaconNumberForProcessing:(int)mbn;

- (void)start;
- (void)stop;

- (void)setRssiThreshold:(int)threshold;

@property (nonatomic, assign) id<NPXLocationEngineDelegate> delegate;

@end
