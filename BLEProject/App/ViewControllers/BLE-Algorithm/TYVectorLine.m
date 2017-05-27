//
//  TYVectorLine.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/22.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYVectorLine.h"

@implementation TYVectorLine

- (id)initWithX1:(double)x1 Y1:(double)y1 X2:(double)x2 Y2:(double)y2
{
    self = [super init];
    if (self) {
        _x1 = x1;
        _y1 = y1;
        _x2 = x2;
        _y2 = y2;
    }
    return self;
}

- (id)initWithP1:(TYLocalPoint *)lp1 P2:(TYLocalPoint *)lp2
{
    return [[[self class] alloc] initWithX1:lp1.x Y1:lp1.y X2:lp2.x Y2:lp2.y];
}

- (TYVectorLine *)projectOfVectorLine:(TYVectorLine *)target
{
    TYVector2D *selfVector = [self toVecotr2D];
    TYVector2D *targetVector = [target toVecotr2D];
    
    TYVector2D *projectVector = [selfVector projectOfVectorWithWrap:targetVector];
//    TYVector2D *projectVector = [selfVector projectOfVector:targetVector];
    
    BRTLog(@"%@", selfVector);
    BRTLog(@"%@", targetVector);
    BRTLog(@"%@", projectVector);

    return [[TYVectorLine alloc] initWithX1:_x1 Y1:_y1 X2:_x1 + projectVector.x Y2:_y1 + projectVector.y];
}

- (TYVector2D *)toVecotr2D
{
    return [[TYVector2D alloc] initWithX:(_x2 - _x1) Y:(_y2 - _y1)];
}

- (AGSGeometry *)toGeometry
{
    AGSMutablePolyline *line = [[AGSMutablePolyline alloc] init];
    [line addPathToPolyline];
    [line addPointToPath:[AGSPoint pointWithX:_x1 y:_y1 spatialReference:nil]];
    [line addPointToPath:[AGSPoint pointWithX:_x2 y:_y2 spatialReference:nil]];
    return line;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"(%f, %f) => (%f, %f)", _x1, _y1, _x2, _y2];
}

@end
