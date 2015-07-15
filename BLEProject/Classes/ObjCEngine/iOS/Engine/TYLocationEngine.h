//
//  CALocationEngine.h
//  BLEProject
//
//  Created by innerpeacer on 15/1/29.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlgorithmType.h"
#import "TYStepEvent.h"

@interface TYLocationEngine : NSObject

+ (TYLocationEngine *)locationEngineWithBeacons:(NSDictionary *)dict;
+ (TYLocationEngine *)locationEngineWithBeacons:(NSDictionary *)dict Type:(AlgorithmType)aType;

- (void)processBeacons:(NSArray *)scannedBeacons;
- (void)addStepEvent:(TYStepEvent *)event;

- (TYLocalPoint *)getLocation;
- (TYLocalPoint *)getDirectioLocation;

@end
