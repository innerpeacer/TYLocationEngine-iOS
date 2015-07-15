//
//  NPLocationFileManager.h
//  CloudAtlasTestProject
//
//  Created by innerpeacer on 15/4/13.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TYMapSDK/TYMapSDK.h>

@interface NPLocationFileManager : NSObject

+ (NSString *)getBeaconRegionDBPath;

+ (NSString *)getBeaconDBPath:(TYBuilding *)building;

@end
