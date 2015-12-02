//
//  TYPointPosition.h
//  BLEProject
//
//  Created by innerpeacer on 15/12/1.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TYMapData/TYMapData.h>

@interface TYPointPosition : NSObject

@property (nonatomic, assign) int tag;
@property (nonatomic, strong) TYLocalPoint *location;

@end
