//
//  TYFanRange.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/15.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYFanRange.h"

#define DEFAULT_HALF_ANGLE 45
#define DEFAULT_FAN_RANGE 5

@interface TYFanRange()
{
    double halfAngle;
    double range;
}

@end

@implementation TYFanRange

- (id)initWithCenter:(TYLocalPoint *)center Heading:(double)heading
{
    self = [super init];
    if (self) {
        _center = center;
        _heading = heading;
        
        halfAngle = DEFAULT_HALF_ANGLE;
        range = DEFAULT_FAN_RANGE;
    }
    return self;
}

- (AGSGeometry *)toFanGeometry
{
    AGSMutablePolygon *polygon = [[AGSMutablePolygon alloc] init];
    [polygon addRingToPolygon];
    [polygon addPointToRing:[AGSPoint pointWithX:_center.x y:_center.y spatialReference:nil]];
    
    double angleStep = 2;
    double startAngle = _heading - halfAngle;
    double endAngle = _heading + halfAngle;
    
    [polygon addPointToRing:[self getPoint:startAngle]];
    for (double angle = startAngle + angleStep; angle < endAngle; angle += angleStep) {
        [polygon addPointToRing:[self getPoint:angle]];
    }
    
    [polygon addPointToRing:[self getPoint:endAngle]];
    return  polygon;
}

- (AGSPoint *)getPoint:(double)angle
{
    double x = _center.x + sin(BRT_ANGLE_TO_RAD(angle)) * range;
    double y = _center.y + cos(BRT_ANGLE_TO_RAD(angle)) * range;
    return [AGSPoint pointWithX:x y:y spatialReference:nil];
}

@end
