//
//  TYVector2D.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/22.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYVector2D : NSObject

@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;

- (id)initWithX:(double)x Y:(double)y;

- (double)length;
- (double)innerProductWithVector:(TYVector2D *)v;
- (double)cosAngleWithVector:(TYVector2D *)v;
- (BOOL)parallelWithVector:(TYVector2D *)v;
- (TYVector2D *)projectOfVector:(TYVector2D *)target;
- (TYVector2D *)projectOfVectorWithWrap:(TYVector2D *)target;
@end
