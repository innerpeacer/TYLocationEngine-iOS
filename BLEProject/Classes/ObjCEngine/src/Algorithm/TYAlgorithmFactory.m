//
//  TYAlgorithmFactory.m
//  BLEProject
//
//  Created by innerpeacer on 15/1/29.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYAlgorithmFactory.h"
#import "TYTriangulationAlgorithm.h"
@implementation TYAlgorithmFactory

+ (TYLocationAlgorithm *)locationAlgorithmWithBeaconDictionary:(NSDictionary *)dict Type:(AlgorithmType)type
{
    switch (type) {
        case Single:
        case Tripple:
        case HybridSingle:
        case HybridTriple:
            return [TYTriangulationAlgorithm algorithmWithBeaconDictionary:dict Type:type];
            
        case LinearWeighting:
        case QuadraticWeighting:
            return [TYWeightingAlgorithm algorithmWithBeaconDictionary:dict Type:type];
            
        default:
            return nil;
            break;
    }
}

@end
