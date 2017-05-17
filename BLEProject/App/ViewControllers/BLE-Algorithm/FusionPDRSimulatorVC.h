//
//  FusionPDRSimulatorVC.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/15.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "BaseMapVC.h"
#import "ArcGISHelper.h"
#import "TYReplayTraceLayer.h"

@interface FusionPDRSimulatorVC : BaseMapVC
@property (nonatomic, strong) NSString *dataID;

@property (nonatomic, strong) TYReplayTraceLayer *fusionStepReplayLayer;

@end
