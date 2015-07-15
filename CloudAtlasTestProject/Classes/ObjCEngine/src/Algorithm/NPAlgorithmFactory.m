//
//  CAAlgorithmFactory.m
//  CloudAtlasTestProject
//
//  Created by innerpeacer on 15/1/29.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "NPAlgorithmFactory.h"
#import "NPTriangulationAlgorithm.h"
@implementation NPAlgorithmFactory

+ (NPLocationAlgorithm *)locationAlgorithmWithBeaconDictionary:(NSDictionary *)dict Type:(AlgorithmType)type
{
    switch (type) {
        case Single:
        case Tripple:
        case HybridSingle:
        case HybridTriple:
            return [NPTriangulationAlgorithm algorithmWithBeaconDictionary:dict Type:type];
            
        case LinearWeighting:
        case QuadraticWeighting:
            return [NPWeightingAlgorithm algorithmWithBeaconDictionary:dict Type:type];
            
        default:
            return nil;
            break;
    }
}

@end
