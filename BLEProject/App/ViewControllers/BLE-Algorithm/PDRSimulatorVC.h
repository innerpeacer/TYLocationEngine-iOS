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

@property (nonatomic, strong) TYReplayTraceLayer *locationReplayLayer;
@property (nonatomic, strong) TYReplayTraceLayer *stepReplayLayer;
@property (nonatomic, strong) TYReplayTraceLayer *updateingStepReplayLayer;
@property (nonatomic, strong) TYReplayTraceLayer *fusionStepReplayLayer;

@end
