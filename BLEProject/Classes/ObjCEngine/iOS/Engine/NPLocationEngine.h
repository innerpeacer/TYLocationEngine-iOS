//
//  CALocationEngine.h
//  BLEProject
//
//  Created by innerpeacer on 15/1/29.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlgorithmType.h"
#import "NPStepEvent.h"

@interface NPLocationEngine : NSObject

+ (NPLocationEngine *)locationEngineWithBeacons:(NSDictionary *)dict;
+ (NPLocationEngine *)locationEngineWithBeacons:(NSDictionary *)dict Type:(AlgorithmType)aType;

- (void)processBeacons:(NSArray *)scannedBeacons;
- (void)addStepEvent:(NPStepEvent *)event;

- (TYLocalPoint *)getLocation;
- (TYLocalPoint *)getDirectioLocation;

@end
