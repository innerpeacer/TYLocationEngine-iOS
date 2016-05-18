//
//  TYPointPosFMDBAdapter.h
//  BLEProject
//
//  Created by innerpeacer on 15/12/1.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TYMapSDK/TYMapSDK.h>
#import "TYPointPosition.h"

@interface TYPointPosFMDBAdapter : NSObject

- (id)initWithBuilding:(TYBuilding *)building;

#pragma mark Database Operation
- (BOOL)open;
- (BOOL)close;

- (BOOL)deletePointPosition:(TYPointPosition *)position;
- (BOOL)deletePointPositionWithIndex:(int)index;
- (BOOL)erasePointPositionTable;

- (BOOL)insertPointPosition:(TYPointPosition *)position;
- (BOOL)updatePointPosition:(TYPointPosition *)position;

- (NSArray *)getAllPointPositions;
- (TYPointPosition *)getPointPositionWithIndex:(int)index;
- (int)getMaxIndex;

@end
