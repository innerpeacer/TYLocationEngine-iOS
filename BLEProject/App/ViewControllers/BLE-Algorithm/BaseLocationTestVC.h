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

@interface BaseLocationTestVC : BaseMapVC

@property (nonatomic, strong) AGSGraphicsLayer *publicBeaconLayer;
@property (nonatomic, strong) AGSGraphicsLayer *signalLayer;

@property (nonatomic, strong) AGSGraphicsLayer *traceLayer;

@property (nonatomic, strong) AGSGraphicsLayer *locationLayer1;
@property (nonatomic, strong) AGSGraphicsLayer *locationLayer2;

@property (nonatomic, strong) AGSPictureMarkerSymbol *locationSymbol;
@property (nonatomic, strong) AGSPictureMarkerSymbol *locationArrowSymbol;

@property (nonatomic, strong) NSMutableArray *debugItems;
@property (nonatomic, assign) BOOL isSignalOn;

@end
