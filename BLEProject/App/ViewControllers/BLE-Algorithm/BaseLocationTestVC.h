//
//  BaseLocationTestVC.h
//  BLEProject
//
//  Created by innerpeacer on 15/1/27.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <TYMapSDK/TYMapSDK.h>
#import "BaseMapVC.h"

#import "TYBeaconFMDBAdapter.h"

#import "TYStepEvent.h"

#import "TYRegionManager.h"
#import "TYLocationEngine.h"

#import "TYBeaconManager.h"

@interface BaseLocationTestVC : BaseMapVC

@property (nonatomic, strong) CLBeaconRegion *publicBeaconRegion;
@property (nonatomic, strong) NSMutableArray *scannedBeacons;
@property (nonatomic, strong) NSMutableDictionary *allBeacons;

@property (nonatomic, strong) TYGraphicsLayer *hintLayer;
@property (nonatomic, strong) TYGraphicsLayer *resultLayer;
@property (nonatomic, strong) TYGraphicsLayer *hintPolygonLayer;



- (void)processLocationResult;
- (void)onStepEvent:(TYStepEvent *)stepEvent;
- (void)showHintRssiForBeacons:(NSArray *)beacons;

@end
