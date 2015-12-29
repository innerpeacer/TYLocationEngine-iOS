//
//  IPBLEWebObjectConverter.m
//  BLEProject
//
//  Created by innerpeacer on 15/12/29.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "IPBLEWebObjectConverter.h"
#import "TYPublicBeacon.h"
#import "TYBeaconRegion.h"

@implementation IPBLEWebObjectConverter

+ (NSString *)prepareJsonString:(id)jsonObject
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (id)parseJsonOjbect:(NSData *)jsonData
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    return jsonObject;
}

+ (NSArray *)prepareBeaconObjectArray:(NSArray *)beaconArray
{
    NSMutableArray *beaconObjectArray = [NSMutableArray array];
    for (TYPublicBeacon *pb in beaconArray) {
        NSDictionary *beaconObject = [TYPublicBeacon buildBeaconObject:pb];
        [beaconObjectArray addObject:beaconObject];
    }
    return beaconObjectArray;
}

+ (NSArray *)parseBeaconArray:(NSArray *)beaconObjectArray
{
    NSMutableArray *beaconArray = [NSMutableArray array];
    for (NSDictionary *beaconObject in beaconObjectArray) {
        TYPublicBeacon *pb = [TYPublicBeacon parseBeaconObject:beaconObject];
        [beaconArray addObject:pb];
    }
    return beaconArray;
}

+ (NSArray *)prepareBeaconRegionObjectArray:(NSArray *)beaconRegionArray
{
    NSMutableArray *beaconRegionObjectArray = [NSMutableArray array];
    for (TYBeaconRegion *region in beaconRegionArray) {
        NSDictionary *beaconRegionObject = [TYBeaconRegion buildRegionObject:region];
        [beaconRegionObjectArray addObject:beaconRegionObject];
    }
    return beaconRegionObjectArray;
}

+ (NSArray *)parseBeaconRegionArray:(NSArray *)beaconRegionObjectArray
{
    NSMutableArray *beaconRegionArray = [NSMutableArray array];
    for (NSDictionary *beaconRegionObject in beaconRegionObjectArray) {
        TYBeaconRegion *region = [TYBeaconRegion parseBeaconRegionObject:beaconRegionObject];
        [beaconRegionArray addObject:region];
    }
    return beaconRegionArray;
}

@end
