//
//  UploadLocatingDataVC.m
//  BLEProject
//
//  Created by innerpeacer on 15/11/15.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "UploadLocatingDataVC.h"
#import <MKNetworkKit/MKNetworkKit.h>
#import "TYUserDefaults.h"
#import "TYPointConverter.h"
#import "TYBeaconFMDBAdapter.h"
#import "IPBLEApi.h"
#import "IPBLEApi_Manager.h"
#import "BLELicenseGenerator.h"
#import "TYUserManager.h"
#import "IPBLEWebObjectConverter.h"
#import "TYMapCredential_Private.h"

#import "IPRegionBeaconUploader.h"
#import "TYRegionManager.h"

@interface UploadLocatingDataVC() <IPRegionBeaconUploaderDelegate>
{
    TYCity *currentCity;
    TYBuilding *currentBuilding;
    NSArray *allMapInfos;
    
    TYMapCredential *user;
    
    NSString *hostName;
    NSString *apiPath;
    
    NSArray *allBeaconArray;
    
    IPRegionBeaconUploader *uploader;
    TYBeaconRegion *beaconRegion;
}

@end

@implementation UploadLocatingDataVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentCity = [TYUserDefaults getDefaultCity];
    currentBuilding = [TYUserDefaults getDefaultBuilding];
    allMapInfos = [TYMapInfo parseAllMapInfo:currentBuilding];
    
    NSLog(@"%@", allMapInfos);
    
    self.title = @"上传Beacon数据";
    
    user = [TYUserManager createSuperUser:currentBuilding.buildingID];
    
    hostName = HOST_NAME;
    apiPath = TY_API_UPLOAD_LOCATING_BEACONS;
    
    [self getAllLocatingBeacons];
    
    uploader = [[IPRegionBeaconUploader alloc] initWithUser:user];
    uploader.delegate = self;
    
    beaconRegion = [TYRegionManager getBeaconRegionForBuilding:currentBuilding.buildingID];
    
//    [uploader uploadBeaconRegions:[TYRegionManager getAllBeaconRegions]];
//    [uploader uploadLocatingBeacons:allBeaconArray];
//    [uploader addBeaconRegion:@[beaconRegion]];
    [uploader uploadLocatingBeacons:allBeaconArray AndBeaconRegion:beaconRegion];
    
}

- (void)RegionBeaconUploader:(IPRegionBeaconUploader *)uploader DidFailedUploadingWithApi:(NSString *)api WithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)RegionBeaconUploader:(IPRegionBeaconUploader *)uploader DidFinishUploadingWithApi:(NSString *)api WithDescription:(NSString *)description
{
    [self addToLog:description];
}

- (void)getAllLocatingBeacons
{
    TYBeaconFMDBAdapter *db = [[TYBeaconFMDBAdapter alloc] initWithBuilding:currentBuilding];
    [db open];
    allBeaconArray = [db getAllLocationingBeacons];
    [db close];
    
    for (TYPublicBeacon *pb in allBeaconArray) {
        TYMapInfo *mapInfo = [TYMapInfo searchMapInfoFromArray:allMapInfos Floor:pb.location.floor];
        if (mapInfo == nil) {
            mapInfo = allMapInfos[0];
        }
        pb.mapID = mapInfo.mapID;
        pb.buildingID = mapInfo.buildingID;
        pb.cityID = mapInfo.buildingID;
    }
    
    NSLog(@"%d beacons", (int)allBeaconArray.count);
}

@end
