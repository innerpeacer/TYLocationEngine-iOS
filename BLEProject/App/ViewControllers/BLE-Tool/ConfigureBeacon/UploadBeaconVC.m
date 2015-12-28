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
//    hostName = LOCAL_HOST_NAME;
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
        
        TYMapInfo *mapInfo = [TYMapInfo searchMapInfoFromArray:allMapInfos Floor:pb.location.floor];
        if (mapInfo == nil) {
            mapInfo = allMapInfos[0];
        }
        pb.mapID = mapInfo.mapID;
        pb.buildingID = mapInfo.buildingID;
        pb.cityID = mapInfo.buildingID;
        
        NSDictionary *beaconObject = [TYPublicBeacon buildBeaconObject:pb];
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
    NSString *beaconString = [[NSString alloc] initWithData:beaconData encoding:NSUTF8StringEncoding];
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
