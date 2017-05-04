//
//  LocationTestHelper.m
//  BLEProject
//
//  Created by innerpeacer on 2017/4/20.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "LocationTestHelper.h"
#import "TYPublicBeacon.h"
#import "TYBeaconFMDBAdapter.h"
#import "IPBeaconDBCodeChecker.h"

@implementation LocationTestHelper

+ (void)showBeaconLocationsWithMapInfo:(TYMapInfo *)mapInfo Building:(TYBuilding *)building OnLayer:(AGSGraphicsLayer *)layer
{
    TYBeaconFMDBAdapter *db = [[TYBeaconFMDBAdapter alloc] initWithBuilding:building];
    [db open];
    
    NSArray *array = [db getAllLocationingBeacons];
    if (array && array.count > 0) {
        NSString *code = [IPBeaconDBCodeChecker checkBeacons:array];
        if ([db getCheckCode]) {
            [db updateCheckCode:code];
        } else {
            [db insertCheckCode:code];
        }
    }
    
    for (TYPublicBeacon *pb in array)
    {
        if (pb.location.floor != mapInfo.floorNumber && pb.location.floor != 0) {
            continue;
        }
        
        AGSPoint *p = [AGSPoint pointWithX:pb.location.x y:pb.location.y spatialReference:nil];
        [TYArcGISDrawer drawPoint:p AtLayer:layer WithColor:[UIColor redColor]];
        
        AGSTextSymbol *ts = [AGSTextSymbol textSymbolWithText:[NSString stringWithFormat:@"%@", pb.minor] color:[UIColor magentaColor]];
        [ts setOffset:CGPointMake(5, -10)];
        [layer addGraphic:[AGSGraphic graphicWithGeometry:p symbol:ts attributes:nil]];
        
        if (pb.tag) {
            AGSTextSymbol *tagTs = [AGSTextSymbol textSymbolWithText:[NSString stringWithFormat:@"%@", pb.tag] color:[UIColor magentaColor]];
            [tagTs setOffset:CGPointMake(5, -24)];
            [layer addGraphic:[AGSGraphic graphicWithGeometry:p symbol:tagTs attributes:nil]];
        }
    }
    [db close];
}

+ (void)showHintRssiForLocationBeacons:(NSArray *)beacons WithMapInfo:(TYMapInfo *)mapInfo OnLayer:(AGSGraphicsLayer *)layer
{
    [layer removeAllGraphics];
    
    for (TYPublicBeacon *pb in beacons) {
        if (pb.location.floor == mapInfo.floorNumber) {
            NSString *rssi = [NSString stringWithFormat:@"%.2f, %d", pb.accuracy,(int) pb.rssi];
            AGSTextSymbol *ts = [AGSTextSymbol textSymbolWithText:rssi color:[UIColor blueColor]];
            [ts setOffset:CGPointMake(5, 10)];
            AGSPoint *pos = [AGSPoint pointWithX:pb.location.x y:pb.location.y spatialReference:nil];
            AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:pos symbol:ts attributes:nil];
            [layer addGraphic:graphic];
            
            AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor redColor]];
            sms.size = CGSizeMake(5, 5);
            [layer addGraphic:[AGSGraphic graphicWithGeometry:pos symbol:sms attributes:nil]];
        }
    }
}

+ (void)encodeBeaconArrayToJson:(NSArray *)array
{
    NSMutableDictionary *rootDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *beaconArray = [[NSMutableArray alloc] init];
    
    [rootDict setObject:beaconArray forKey:@"beacons"];
    
    for (TYPublicBeacon *pb in array) {
        NSMutableDictionary *beaconDict = [[NSMutableDictionary alloc] init];
        [beaconDict setObject:pb.UUID forKey:@"uuid"];
        [beaconDict setObject:pb.major forKey:@"major"];
        [beaconDict setObject:pb.minor forKey:@"minor"];
        [beaconDict setObject:@(pb.location.x) forKey:@"x"];
        [beaconDict setObject:@(pb.location.y) forKey:@"y"];
        [beaconDict setObject:@(pb.location.floor) forKey:@"floor"];
        
        [beaconArray addObject:beaconDict];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:rootDict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"beacon.json"];
    NSLog(@"%@", documentDirectory);
    [data writeToFile:path atomically:YES];
}

+ (void)encodeBeaconJsonForServer:(NSArray *)array Building:(TYBuilding *)building MapInfos:(NSArray *)mapInfoArray
{
    NSMutableDictionary *rootDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *beaconArray = [[NSMutableArray alloc] init];
    
    [rootDict setObject:beaconArray forKey:@"beacons"];
    
    for (TYPublicBeacon *pb in array) {
        NSMutableDictionary *beaconDict = [[NSMutableDictionary alloc] init];
        [beaconDict setObject:pb.UUID forKey:@"uuid"];
        [beaconDict setObject:pb.major forKey:@"major"];
        [beaconDict setObject:pb.minor forKey:@"minor"];
        [beaconDict setObject:@(pb.location.x) forKey:@"x"];
        [beaconDict setObject:@(pb.location.y) forKey:@"y"];
        [beaconDict setObject:@(pb.location.floor) forKey:@"floor"];
        
        [beaconDict setObject:building.cityID forKey:@"cityID"];
        [beaconDict setObject:building.buildingID forKey:@"buildingID"];
        for (TYMapInfo *info in mapInfoArray) {
            if (info.floorNumber == pb.location.floor) {
                [beaconDict setObject:info.mapID forKey:@"mapID"];
            }
        }
        
        [beaconArray addObject:beaconDict];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:rootDict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"beaconForServer.json"];
    NSLog(@"%@", documentDirectory);
    [data writeToFile:path atomically:YES];
}

@end
