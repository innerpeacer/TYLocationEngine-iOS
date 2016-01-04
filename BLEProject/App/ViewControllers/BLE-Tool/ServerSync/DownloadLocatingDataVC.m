//
//  DownloadLocatingDataVC.m
//  BLEProject
//
//  Created by innerpeacer on 16/1/2.
//  Copyright © 2016年 innerpeacer. All rights reserved.
//

#import "DownloadLocatingDataVC.h"

#import "TYUserManager.h"
#import "TYUserDefaults.h"

#import "IPRegionBeaconDownloader.h"

@interface DownloadLocatingDataVC() <IPRegionBeaconDownloaderDelegate>
{
    TYCity *currentCity;
    TYBuilding *currentBuilding;
    
    TYMapCredential *user;

    IPRegionBeaconDownloader *downloader;
}

- (IBAction)downloadAllBeaconRegions:(id)sender;
- (IBAction)downloadCurrentLocatingData:(id)sender;

@end


@implementation DownloadLocatingDataVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"下载定位数据";

    
    currentCity = [TYUserDefaults getDefaultCity];
    currentBuilding = [TYUserDefaults getDefaultBuilding];
    
    user = [TYUserManager createSuperUser:currentBuilding.buildingID];

    downloader = [[IPRegionBeaconDownloader alloc] initWithUser:user];
    downloader.delegate = self;
}

- (void)RegionBeaconDownloader:(IPRegionBeaconDownloader *)downloader DidFailedDownloadingWithApi:(NSString *)api WithError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
    [self addToLog:[error localizedDescription]];
}

- (void)RegionBeaconDownloader:(IPRegionBeaconDownloader *)downloader DidFinishDownloadingWithApi:(NSString *)api WithResult:(NSArray *)resultArray Records:(int)records
{
    if ([api isEqualToString:TY_API_GET_ALL_BEACON_REGIONS] || [api isEqualToString:TY_API_GET_TARGET_BEACON_REGION]) {
        [self addToLog:[NSString stringWithFormat:@"Records: %d", records]];
        [self addToLog:[NSString stringWithFormat:@"Get %d regions From Server", records]];
    }
    
    if ([api isEqualToString:TY_API_GET_TARGET_LOCATING_BEACONS]) {
        [self addToLog:[NSString stringWithFormat:@"Records: %d", records]];
        [self addToLog:[NSString stringWithFormat:@"Get %d beacons From Server", records]];
    }
}

- (void)RegionBeaconDownloader:(IPRegionBeaconDownloader *)downloader DidFinishDownloadingWithRegion:(TYBeaconRegion *)region WithBeacons:(NSArray *)beacons
{
    [self addToLog:@"Get Region From Server:"];
    [self addToLog:[NSString stringWithFormat:@"%@", region.region]];
    [self addToLog:[NSString stringWithFormat:@"Get %d beacons From Server", (int)beacons.count]];
}

- (IBAction)downloadAllBeaconRegions:(id)sender
{
    NSLog(@"downloadAllBeaconRegions");
    [downloader getAllBeaconRegions];
}

- (IBAction)downloadCurrentLocatingData:(id)sender
{
    NSLog(@"downloadCurrentLocatingData");
//    [downloader getBeaconRegion];
//    [downloader getLocatingBeacons];
    [downloader getRegionAndBeacons];
}

@end
