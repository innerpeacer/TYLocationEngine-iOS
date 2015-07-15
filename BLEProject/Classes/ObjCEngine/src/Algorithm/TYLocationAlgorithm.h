//
//  CALocationAlgorithm.h
//  BLEProject
//
//  Created by innerpeacer on 15/1/28.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  定位算法类
 */
@interface TYLocationAlgorithm : NSObject

/**
 *  当前部署的Beacon信息: {NSNumber: CAPublicBeacon}
 */
@property (nonatomic, strong) NSDictionary *beaconDictionary;

/**
 *  当前设备扫描到的beacon数据，用于算法输入。
 */
@property (nonatomic, strong) NSArray *nearestBeacons;

/**
 *  初始化定位算法
 *
 *  @param dict 当前部署的Beacon信息: {NSNumber: CAPublicBeacon}
 *
 */
- (id)initWithBeaconDictionary:(NSDictionary *)dict;

/**
 *  通用接口，根据当前扫描到的beacon信息，计算当前位置
 *
 *  @return 当前位置信息
 */
- (TYLocalPoint *)calculationLocation;


@end
