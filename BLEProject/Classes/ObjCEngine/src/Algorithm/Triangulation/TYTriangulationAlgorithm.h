//
//  CALTSTriangulationAlgorithm.h
//  BLEProject
//
//  Created by innerpeacer on 15/1/29.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYLocationAlgorithm.h"
#import "AlgorithmType.h"

/**
 *  三角定位子算法，父类为CALocationAlgorithm
 */
@interface TYTriangulationAlgorithm : TYLocationAlgorithm

+ (TYTriangulationAlgorithm *)algorithmWithBeaconDictionary:(NSDictionary *)dict Type:(AlgorithmType)type;

@end

