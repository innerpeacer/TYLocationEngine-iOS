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

- (id)init
{
    self = [super init];
    if (self) {
        halfAngle = DEFAULT_HALF_ANGLE;
        range = DEFAULT_FAN_RANGE;
    }
    return self;
}

- (id)initWithCenter:(TYLocalPoint *)center Heading:(NSNumber *)heading
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

- (BOOL)containPoint:(TYLocalPoint *)lp
{
    if (_center == nil || _heading == nil) {
        return NO;
    }
    
    double distance = [_center distanceWith:lp];
    if (distance < 0.1) {
        return YES;
    }
    
    if (distance > range) {
        return NO;
    }
    
    TYLocalPoint *headingPoint = [self getLocalPoint:_heading.doubleValue];
    
    CGVector vecHeading = CGVectorMake(headingPoint.x - _center.x, headingPoint.y - _center.y);
    CGVector vecTarget = CGVectorMake(lp.x - _center.x, lp.y - _center.y);
    
    double lengthOfHeading = sqrt(vecHeading.dx * vecHeading.dx + vecHeading.dy * vecHeading.dy);
    double lengthOfPoint = sqrt(vecTarget.dx * vecTarget.dx + vecTarget.dy * vecTarget.dy);
    double innerProduct = (vecHeading.dx * vecTarget.dx) + (vecHeading.dy * vecTarget.dy);
    double angleCos = innerProduct / (lengthOfPoint * lengthOfHeading);
    if (angleCos > cos(BRT_RAD_TO_ANGLE(halfAngle))) {
        return YES;
    }
    
//    BRTLog(@"Cos: %f", angleCos);
    BRTLog(@"Angle: %f", BRT_RAD_TO_ANGLE(acos(angleCos)));
    return NO;
}

- (LocationRangeStatus)getStatus:(TYLocalPoint *)lp
{
    if (_center == nil || _heading == nil) {
        return IP_Unknown;
    }
    
    double distance = [_center distanceWith:lp];
    if (distance < 0.1) {
        return IP_Contain;
    }
    
    TYLocalPoint *headingPoint = [self getLocalPoint:_heading.doubleValue];
    
    CGVector vecHeading = CGVectorMake(headingPoint.x - _center.x, headingPoint.y - _center.y);
    CGVector vecTarget = CGVectorMake(lp.x - _center.x, lp.y - _center.y);
    
    double lengthOfHeading = sqrt(vecHeading.dx * vecHeading.dx + vecHeading.dy * vecHeading.dy);
    double lengthOfPoint = sqrt(vecTarget.dx * vecTarget.dx + vecTarget.dy * vecTarget.dy);
    double innerProduct = (vecHeading.dx * vecTarget.dx) + (vecHeading.dy * vecTarget.dy);
    double angleCos = innerProduct / (lengthOfPoint * lengthOfHeading);
    if (angleCos > cos(BRT_RAD_TO_ANGLE(halfAngle))) {
        return IP_Forward;
    }
    return IP_Backward;
    
}

- (AGSGeometry *)toFanGeometry
{
    if (_center == nil || _heading == nil) {
        return nil;
    }
    
    AGSMutablePolygon *polygon = [[AGSMutablePolygon alloc] init];
    [polygon addRingToPolygon];
    [polygon addPointToRing:[AGSPoint pointWithX:_center.x y:_center.y spatialReference:nil]];
    
    double angleStep = 2;
    double startAngle = _heading.doubleValue - halfAngle;
    double endAngle = _heading.doubleValue + halfAngle;
    
    [polygon addPointToRing:[self getPoint:startAngle]];
    for (double angle = startAngle + angleStep; angle < endAngle; angle += angleStep) {
        [polygon addPointToRing:[self getPoint:angle]];
    }
    
    [polygon addPointToRing:[self getPoint:endAngle]];
    return  polygon;
}

- (TYLocalPoint *)getLocalPoint:(double)angle
{
    double x = _center.x + sin(BRT_ANGLE_TO_RAD(angle)) * range;
    double y = _center.y + cos(BRT_ANGLE_TO_RAD(angle)) * range;
    return [TYLocalPoint pointWithX:x Y:y Floor:_center.floor];
}

- (AGSPoint *)getPoint:(double)angle
{
    double x = _center.x + sin(BRT_ANGLE_TO_RAD(angle)) * range;
    double y = _center.y + cos(BRT_ANGLE_TO_RAD(angle)) * range;
    return [AGSPoint pointWithX:x y:y spatialReference:nil];
}

@end
