//
//  TYVector2.m
//  BLEProject
//
//  Created by innerpeacer on 15/4/17.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYVector2.h"
#import "BLELocationEngineConstants.h"

@implementation TYVector2

- (double)getAngle
{
    if (_y == 0 && _x >= 0) {
        return 90.0;
    }
    
    if (_y == 0 && _x < 0) {
        return -90.0;
    }
    
    double rad = atan(_x / _y);
    double angle = (rad * 180) / PI;
    if (_y < 0) {
        if (_x > 0) {
            angle = angle + 180;
        } else {
            angle = angle - 180;
        }
    }
    return angle;
}

@end
