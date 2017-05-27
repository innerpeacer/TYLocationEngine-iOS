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
    
    TYLocalPoint *center;
    NSNumber *heading;
}

@end

@implementation TYFanRange
@synthesize center = center;

- (id)init
{
    self = [super init];
    if (self) {
        halfAngle = DEFAULT_HALF_ANGLE;
        range = DEFAULT_FAN_RANGE;
    }
    return self;
}

- (id)initWithCenter:(TYLocalPoint *)c Heading:(NSNumber *)h
{
    self = [super init];
    if (self) {
        center = c;
        heading = h;
        
        halfAngle = DEFAULT_HALF_ANGLE;
        range = DEFAULT_FAN_RANGE;
    }
    return self;
}

- (void)updateCenter:(TYLocalPoint *)c
{
    center = c;
}

- (void)updateHeading:(double)h
{
    heading = @(h);
}

- (BOOL)containPoint:(TYLocalPoint *)lp
{
    if (center == nil || heading == nil) {
        return NO;
    }
    
    double distance = [center distanceWith:lp];
    if (distance < 0.1) {
        return YES;
    }
    
    if (distance > range) {
        return NO;
    }
    
    TYLocalPoint *headingPoint = [self getLocalPoint:heading.doubleValue];
    
    CGVector vecHeading = CGVectorMake(headingPoint.x - center.x, headingPoint.y - center.y);
    CGVector vecTarget = CGVectorMake(lp.x - center.x, lp.y - center.y);
    
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
    if (center == nil || heading == nil) {
        return IP_Unknown;
    }
    
    double distance = [center distanceWith:lp];
    if (distance < 0.1) {
        return IP_Contain;
    }
    
    TYLocalPoint *headingPoint = [self getLocalPoint:heading.doubleValue];
    
    CGVector vecHeading = CGVectorMake(headingPoint.x - center.x, headingPoint.y - center.y);
    CGVector vecTarget = CGVectorMake(lp.x - center.x, lp.y - center.y);
    
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
    if (center == nil || heading == nil) {
        return nil;
    }
    
    AGSMutablePolygon *polygon = [[AGSMutablePolygon alloc] init];
    [polygon addRingToPolygon];
    [polygon addPointToRing:[AGSPoint pointWithX:center.x y:center.y spatialReference:nil]];
    
    double angleStep = 2;
    double startAngle = heading.doubleValue - halfAngle;
    double endAngle = heading.doubleValue + halfAngle;
    
    [polygon addPointToRing:[self getPoint:startAngle]];
    for (double angle = startAngle + angleStep; angle < endAngle; angle += angleStep) {
        [polygon addPointToRing:[self getPoint:angle]];
    }
    
    [polygon addPointToRing:[self getPoint:endAngle]];
    return  polygon;
}

- (TYLocalPoint *)getLocalPoint:(double)angle
{
    double x = center.x + sin(BRT_ANGLE_TO_RAD(angle)) * range;
    double y = center.y + cos(BRT_ANGLE_TO_RAD(angle)) * range;
    return [TYLocalPoint pointWithX:x Y:y Floor:center.floor];
}

- (AGSPoint *)getPoint:(double)angle
{
    double x = center.x + sin(BRT_ANGLE_TO_RAD(angle)) * range;
    double y = center.y + cos(BRT_ANGLE_TO_RAD(angle)) * range;
    return [AGSPoint pointWithX:x y:y spatialReference:nil];
}

@end
