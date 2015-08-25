//
//  TYBeaconRegion.h
//  TYMapLocationDemo
//
//  Created by innerpeacer on 15/8/14.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TYBeaconRegion : NSObject

@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, strong) NSString *buildingID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CLBeaconRegion *region;

@end
