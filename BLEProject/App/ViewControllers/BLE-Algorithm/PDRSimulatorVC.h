//
//  PDRSimulatorVC.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/11.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "BaseMapVC.h"
#import "ArcGISHelper.h"
#import "TYReplayTraceLayer.h"

@interface PDRSimulatorVC : BaseMapVC
@property (nonatomic, strong) NSString *dataID;

@property (nonatomic, strong) AGSGraphicsLayer *publicBeaconLayer;
@property (nonatomic, strong) AGSGraphicsLayer *signalLayer;

@property (nonatomic, strong) AGSGraphicsLayer *traceLayer1;
@property (nonatomic, strong) AGSGraphicsLayer *traceLayer2;

@property (nonatomic, strong) AGSGraphicsLayer *locationLayer1;
@property (nonatomic, strong) AGSGraphicsLayer *locationLayer2;

@property (nonatomic, strong) AGSGraphicsLayer *hintLayer;

@property (nonatomic, strong) TYReplayTraceLayer *locationReplayLayer;
@property (nonatomic, strong) TYReplayTraceLayer *stepReplayLayer;

@property (nonatomic, strong) AGSPictureMarkerSymbol *locationSymbol;
@property (nonatomic, strong) AGSPictureMarkerSymbol *locationArrowSymbol;



@end
