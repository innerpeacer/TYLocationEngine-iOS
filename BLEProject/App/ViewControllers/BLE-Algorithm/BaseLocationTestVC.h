//
//  BaseLocationTestVC.h
//  BLEProject
//
//  Created by innerpeacer on 2017/4/30.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "BaseMapVC.h"
#import "ArcGISHelper.h"
#import "DebugItem.h"
#import "TYLocationManager.h"

@interface BaseLocationTestVC : BaseMapVC <TYLocationManagerDelegate>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) AGSGraphicsLayer *publicBeaconLayer;
@property (nonatomic, strong) AGSGraphicsLayer *signalLayer;

@property (nonatomic, strong) AGSGraphicsLayer *traceLayer1;
@property (nonatomic, strong) AGSGraphicsLayer *traceLayer2;

@property (nonatomic, strong) AGSGraphicsLayer *locationLayer1;
@property (nonatomic, strong) AGSGraphicsLayer *locationLayer2;

@property (nonatomic, strong) AGSGraphicsLayer *hintLayer;

@property (nonatomic, strong) AGSPictureMarkerSymbol *locationSymbol;
@property (nonatomic, strong) AGSPictureMarkerSymbol *locationArrowSymbol;

@property (nonatomic, strong) NSMutableArray *debugItems;
@property (nonatomic, assign) BOOL isSignalOn;

@property (nonatomic, strong) TYLocationManager *locationManager;
@property (nonatomic, strong) CLBeaconRegion *publicBeaconRegion;
- (void)tableViewFinished;

@end
