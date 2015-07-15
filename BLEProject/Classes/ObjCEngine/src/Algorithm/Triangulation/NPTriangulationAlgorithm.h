//
//  CALTSTriangulationAlgorithm.h
//  BLEProject
//
//  Created by innerpeacer on 15/1/29.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPLocationAlgorithm.h"
#import "AlgorithmType.h"

/**
 *  三角定位子算法，父类为CALocationAlgorithm
 */
@interface NPTriangulationAlgorithm : NPLocationAlgorithm

+ (NPTriangulationAlgorithm *)algorithmWithBeaconDictionary:(NSDictionary *)dict Type:(AlgorithmType)type;

@end

