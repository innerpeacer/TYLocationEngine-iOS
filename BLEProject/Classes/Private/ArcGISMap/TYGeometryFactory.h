//
//  CAGeometryFactory.h
//  BLEProject
//
//  Created by innerpeacer on 15/1/28.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

/**
 *  几何辅助类
 */
@interface TYGeometryFactory : NSObject

/**
 *  生成一组点的凸包
 *
 *  @param points 点数组 [AGSPoint]
 *
 *  @return 凸包多边形
 */
+ (AGSPolygon *)convexHullFromPoints:(NSArray *)points;

@end
