//
//  TYLocationFileManager.h
//  BLEProject
//
//  Created by innerpeacer on 15/4/13.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TYMapData/TYMapData.h>

@interface TYLocationFileManager : NSObject

+ (NSString *)getBeaconRegionDBPath;

+ (NSString *)getBeaconDBPath:(TYBuilding *)building;

@end