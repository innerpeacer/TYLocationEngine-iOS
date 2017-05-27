//
//  TYVector2D.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/22.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYVector2D.h"

@implementation TYVector2D

- (id)initWithX:(double)x Y:(double)y
{
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
    }
    return self;
}

- (double)length
{
    return sqrt(_x * _x + _y + _y);
}

- (TYVector2D *)scaleVector:(double)scale
{
    return [[TYVector2D alloc] initWithX:_x * scale Y:_y * scale];
}

- (double)innerProductWithVector:(TYVector2D *)v
{
    return _x * v.x + _y * v.y;
}

- (double)cosAngleWithVector:(TYVector2D *)v
{
    double innerProduct = [self innerProductWithVector:v];
    return innerProduct / ([self length] * [v length]);
}

- (BOOL)parallelWithVector:(TYVector2D *)v
{
    return (_x * v.y == _y * v.x);
}

- (TYVector2D *)projectOfVector:(TYVector2D *)target
{
    double innerProduct = [self innerProductWithVector:target];
    double lengthSquared = (_x * _x + _y * _y);
    double scale = innerProduct / lengthSquared;
    return [self scaleVector:scale];
}

- (TYVector2D *)projectOfVectorWithWrap:(TYVector2D *)target
{
    double innerProduct = [self innerProductWithVector:target];
    double lengthSquared = (_x * _x + _y * _y);
    double scale = innerProduct / lengthSquared;
    
    if (scale < 0) {
        return [[TYVector2D alloc] initWithX:0 Y:0];
    }
    
    if (scale > 1) {
        return [[TYVector2D alloc] initWithX:self.x Y:self.y];
;
    }
    
    return [self scaleVector:scale];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"(%f, %f)", _x, _y];
}

@end
