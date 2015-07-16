//
//  TYGeometryFactory.m
//  BLEProject
//
//  Created by innerpeacer on 15/1/28.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYGeometryFactory.h"

@implementation TYGeometryFactory

+ (AGSPolygon *)convexHullFromPoints:(NSArray *)points
{
    
    AGSPolygon *resultPolygon = [[AGSPolygon alloc] init];
    if (points.count < 3) {
        return resultPolygon;
    }
    
    AGSGeometryEngine *engine = [AGSGeometryEngine defaultGeometryEngine];
    AGSPoint *firstPoint = points[0];
    AGSPoint *secondPoint = points[1];
    
    for (int i = 2; i < points.count; i++) {
        AGSPoint *thirdPoint = points[i];
        
        AGSMutablePolygon *newPortion = [[AGSMutablePolygon alloc] init];
        [newPortion addRingToPolygon];
        [newPortion addPointToRing:firstPoint];
        [newPortion addPointToRing:secondPoint];
        [newPortion addPointToRing:thirdPoint];
        
        resultPolygon = (AGSPolygon *)[engine unionGeometries:@[resultPolygon, newPortion]];
    }
    
    return (AGSPolygon *)[engine convexHullForGeometry:resultPolygon];
}

@end
