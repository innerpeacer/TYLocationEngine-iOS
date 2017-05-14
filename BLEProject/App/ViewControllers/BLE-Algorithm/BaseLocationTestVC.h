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

@property (nonatomic, assign) BOOL isSignalOn;

@property (nonatomic, strong) TYLocationManager *locationManager;
@property (nonatomic, strong) CLBeaconRegion *publicBeaconRegion;
- (void)tableViewFinished;

@end
