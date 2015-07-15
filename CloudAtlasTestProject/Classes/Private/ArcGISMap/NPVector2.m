////
////  CAVector.m
////  CloudAtlasTestProject
////
////  Created by innerpeacer on 15/1/28.
////  Copyright (c) 2015年 innerpeacer. All rights reserved.
////
//
//#import "NPVector2.h"
//#include <math.h>
//
//#define PI 3.1415926
//
//@implementation NPVector2
//
//+ (NPVector2 *)vectorWithX:(double)x Y:(double)y
//{
//    return [[NPVector2 alloc] initWithX:x Y:y];
//}
//
//- (id)initWithX:(double)x Y:(double)y
//{
//    self = [super init];
//    if (self) {
//        _x = x;
//        _y = y;
//    }
//    return self;
//}
//
//// North = 0;
//// East = 90;
//// South = 180;
//// West = 270
//- (float)getAngle
//{
//    double angle = 0;
//    if (_y >= 0 && _x == 0) angle = 0;
//    if (_y < 0 && _x == 0) angle = 180;
//    if (_y == 0 && _x > 0) angle = 90;
//    if (_y == 0 && _x < 0) angle = 270;
//
//    if (_y > 0 && _x > 0) angle = atan(_x/_y) * (180/PI);
//    if (_y > 0 && _x < 0) angle = atan(_x/_y) * (180/PI) + 360;
//    if (_y < 0 && _x > 0) angle = atan(_x/_y) * (180/PI) + 180;
//    if (_y < 0 && _x < 0) angle = atan(_x/_y) * (180/PI) + 180;
//    
//    return  angle;
//}
//
//// North = 0;
//// South = 180 || -180;
//// East = 90
//// West = -90
//- (float)getMapAngle
//{
//    double angle = 0;
//    if (_y >= 0 && _x == 0) angle = 0;
//    if (_y < 0 && _x == 0) angle = -180;
//    if (_y == 0 && _x > 0) angle = 90;
//    if (_y == 0 && _x < 0) angle = -90;
//    
//    if (_y > 0 && _x > 0) angle = atan(_x/_y) * (180/PI);
//    if (_y > 0 && _x < 0) angle = atan(_x/_y) * (180/PI);
//    if (_y < 0 && _x > 0) angle = atan(_x/_y) * (180/PI) + 180;
//    if (_y < 0 && _x < 0) angle = atan(_x/_y) * (180/PI) - 180;
//    
//    return  angle;
//}
//
//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"(%f, %f)", _x, _y];
//}
//
//@end
