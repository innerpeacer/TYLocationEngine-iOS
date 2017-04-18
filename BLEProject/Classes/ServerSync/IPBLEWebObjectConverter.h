//
//  IPBLEWebObjectConverter.h
//  BLEProject
//
//  Created by innerpeacer on 15/12/29.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPBLEWebObjectConverter : NSObject

+ (NSString *)prepareJsonString:(id)jsonObject;
+ (id)parseJsonOjbect:(NSData *)jsonData;

+ (NSArray *)prepareBeaconObjectArray:(NSArray *)beaconArray;
+ (NSArray *)parseBeaconArray:(NSArray *)beaconObjectArray;

+ (NSArray *)prepareBeaconRegionObjectArray:(NSArray *)beaconRegionArray;
+ (NSArray *)parseBeaconRegionArray:(NSArray *)beaconRegionObjectArray;

@end
