//
//  CAAlgorithmFactory.h
//  BLEProject
//
//  Created by innerpeacer on 15/1/29.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPLocationAlgorithm.h"
#import "NPWeightingAlgorithm.h"
#import "AlgorithmType.h"

/**
 *  算法工厂，根据特定类型返回相应的算法实例
 */
@interface NPAlgorithmFactory : NSObject

/**
 *  算法实例静态工厂方法
 *
 *  @param dict 当前部署的Beacon信息: {NSNumber: CAPublicBeacon}
 *  @param type 当前算法类型
 *
 *  @return 对应于type的算法实例
 */
+ (NPLocationAlgorithm *)locationAlgorithmWithBeaconDictionary:(NSDictionary *)dict Type:(AlgorithmType)type;

@end
