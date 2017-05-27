//
//  TYVectorLine.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/22.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TYMapData/TYMapData.h>
#import "TYVector2D.h"
#import <ArcGIS/ArcGIS.h>

@interface TYVectorLine : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) double x1;
@property (nonatomic, assign) double y1;

@property (nonatomic, assign) double x2;
@property (nonatomic, assign) double y2;

- (id)initWithP1:(TYLocalPoint *)lp1 P2:(TYLocalPoint *)lp2;

- (TYVector2D *)toVecotr2D;
- (AGSGeometry *)toGeometry;

- (TYVectorLine *)projectOfVectorLine:(TYVectorLine *)line;

@end
