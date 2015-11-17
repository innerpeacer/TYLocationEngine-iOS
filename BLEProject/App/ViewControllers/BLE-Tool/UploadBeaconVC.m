//
//  UploadBeaconVC.m
//  BLEProject
//
//  Created by innerpeacer on 15/11/15.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "UploadBeaconVC.h"
//#import "MKNetworkKit.h"
#import <MKNetworkKit/MKNetworkKit.h>
#import "TYUserDefaults.h"
#import "TYPointConverter.h"
#import "TYBeaconFMDBAdapter.h"

#import "BLELicenseGenerator.h"
@interface UploadBeaconVC()
{
    TYCity *currentCity;
    TYBuilding *currentBuilding;
    NSArray *allMapInfos;
    
    NSString *userID;
    NSString *buildingID;
    NSString *license;
    
    NSString *hostName;
    NSString *apiPath;
    
    NSArray *allBeaconArray;
}

@end

@implementation UploadBeaconVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentCity = [TYUserDefaults getDefaultCity];
    currentBuilding = [TYUserDefaults getDefaultBuilding];
    allMapInfos = [TYMapInfo parseAllMapInfo:currentBuilding];
    
    NSLog(@"%@", allMapInfos);
    
    self.title = @"上传Beacon数据";
    
    userID = SUPER_USER_ID;
//    userID = @"fafasfaag";
    buildingID = currentBuilding.buildingID;
    license = [BLELicenseGenerator generateLicenseForUserID:userID Building:buildingID ExpiredDate:TRIAL_EXPRIED_DATE];
    
//    hostName = @"localhost:8112";
    hostName = SERVER_HOST_NAME;
    apiPath = [[NSString alloc] initWithFormat:@"/TYMapServerManager/manager/beacon/UploadLocatingBeacons"];
    
    [self getAllLocatingBeacons];
    [self testUploadLocatingBeaconUsingHttpPost];
}

- (void)getAllLocatingBeacons
{
    TYBeaconFMDBAdapter *db = [[TYBeaconFMDBAdapter alloc] initWithBuilding:currentBuilding];
    [db open];
    allBeaconArray = [db getAllLocationingBeacons];
    [db close];
    NSLog(@"%d beacons", (int)allBeaconArray.count);
}

- (NSArray *)prepareBeaconArray
{
    NSDate *now = [NSDate date];
    NSMutableArray *beaconArray = [NSMutableArray array];
    
    for (TYPublicBeacon *pb in allBeaconArray) {
        NSMutableDictionary *beaconObject = [NSMutableDictionary dictionary];
        
        TYMapInfo *mapInfo = [TYMapInfo searchMapInfoFromArray:allMapInfos Floor:pb.location.floor];
        if (mapInfo == nil) {
            mapInfo = allMapInfos[0];
        }
        
        [beaconObject setObject:pb.UUID forKey:@"uuid"];
        [beaconObject setObject:pb.major forKey:@"major"];
        [beaconObject setObject:pb.minor forKey:@"minor"];
        
        [beaconObject setObject:@(pb.location.floor) forKey:@"floor"];
        [beaconObject setObject:@(pb.location.x) forKey:@"x"];
        [beaconObject setObject:@(pb.location.y) forKey:@"y"];
        
        [beaconObject setObject:mapInfo.mapID forKey:@"mapID"];
        [beaconObject setObject:currentBuilding.buildingID forKey:@"buildingID"];
        [beaconObject setObject:currentBuilding.cityID forKey:@"cityID"];
        
        NSData *geometryData = [TYPointConverter dataFromX:pb.location.x Y:pb.location.y Z:0];
        NSMutableArray *geometryByteArray = [NSMutableArray array];
        Byte *bytes = (Byte *)geometryData.bytes;
        for (int i = 0; i < geometryData.length; ++i) {
            [geometryByteArray addObject:@(bytes[i])];
        }
        [beaconObject setObject:geometryByteArray forKey:@"geometry"];
        
        [beaconArray addObject:beaconObject];
    }
    
    NSLog(@"Time Interval: %f", [[NSDate date] timeIntervalSinceDate:now]);
    return beaconArray;
}

- (void)testUploadLocatingBeaconUsingHttpPost
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userID forKey:@"userID"];
    [param setValue:buildingID forKey:@"buildingID"];
    [param setValue:license forKey:@"license"];
    
    NSArray *beaconArray = [self prepareBeaconArray];
    NSData *beaconData = [NSJSONSerialization dataWithJSONObject:beaconArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *beaconString = [NSString stringWithCString:beaconData.bytes encoding:NSUTF8StringEncoding];
    [param setValue:beaconString forKey:@"beacons"];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:hostName];
    MKNetworkOperation *op = [engine operationWithPath:apiPath params:param httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
//        NSLog(@"ResponseData: %@", [operation responseString]);
//        [self addToLog:@"Response String:"];
        [self addToLog:[operation responseString]];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
    
    [engine enqueueOperation:op];
}

@end
