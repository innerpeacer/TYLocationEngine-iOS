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
#import "TYUserManager.h"
#import "IPBLEWebObjectConverter.h"

#import "IPRegionBeaconUploader.h"
#import "TYRegionManager.h"

@interface UploadLocatingDataVC() <IPRegionBeaconUploaderDelegate>
{
    TYCity *currentCity;
    TYBuilding *currentBuilding;
    NSArray *allMapInfos;
    
    TYMapCredential *user;
    
    NSArray *allBeaconArray;
    
    IPRegionBeaconUploader *uploader;
    TYBeaconRegion *beaconRegion;
}

- (IBAction)uploadAllBeaconRegions:(id)sender;
- (IBAction)uploadCurrentLocatingData:(id)sender;

@end

@implementation UploadLocatingDataVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentCity = [TYUserDefaults getDefaultCity];
    currentBuilding = [TYUserDefaults getDefaultBuilding];
    allMapInfos = [TYMapInfo parseAllMapInfo:currentBuilding];
    
    NSLog(@"%@", allMapInfos);
    
    self.title = @"上传定位数据";
    
    user = [TYUserManager createSuperUser:currentBuilding.buildingID];
    
    [self getAllLocatingBeacons];
    
    uploader = [[IPRegionBeaconUploader alloc] initWithUser:user];
    uploader.delegate = self;
    
    beaconRegion = [TYRegionManager getBeaconRegionForBuilding:currentBuilding.buildingID];
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

- (IBAction)uploadAllBeaconRegions:(id)sender
{
    [uploader uploadBeaconRegions:[TYRegionManager getAllBeaconRegions]];
}

- (IBAction)uploadCurrentLocatingData:(id)sender
{
    [uploader uploadLocatingBeacons:allBeaconArray AndBeaconRegion:beaconRegion];
//    [uploader addLocatingBeacons:allBeaconArray];
}

@end
