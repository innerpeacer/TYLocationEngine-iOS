//
//  TYPDRController.h
//  BLEProject
//
//  Created by innerpeacer on 2017/4/20.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TYMapData/TYMapData.h>

@interface TYSimplePDRController : NSObject

- (id)initWithAngle:(double)angle;

@property (nonatomic, strong) TYLocalPoint *currentLocation;

- (void)setStartLocation:(TYLocalPoint *)start;

- (void)addStepEvent;
- (void)updateHeading:(double)newHeading;

@end
