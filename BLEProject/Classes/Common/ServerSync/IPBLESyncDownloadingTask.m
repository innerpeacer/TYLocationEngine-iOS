//
//  IPBLESyncDownloadingTask.m
//  BLEProject
//
//  Created by innerpeacer on 16/1/3.
//  Copyright © 2016年 innerpeacer. All rights reserved.
//

#import "IPBLESyncDownloadingTask.h"

#import "IPRegionBeaconDownloader.h"

@interface IPBLESyncDownloadingTask() <IPRegionBeaconDownloaderDelegate>
{
    TYBeaconRegion *beaconRegion;
    
    IPRegionBeaconDownloader *downloader;
}

@end

@implementation IPBLESyncDownloadingTask

- (id)initWithUser:(TYMapCredential *)u
{
    self = [super init];
    if (self) {
        downloader = [[IPRegionBeaconDownloader alloc] initWithUser:u];
        downloader.delegate = self;
    }
    return self;
}

- (void)featchData
{
    [downloader getRegionAndBeacons];
}

- (void)notifyFailedDownloadingWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DownloadingTaskDidFailedDownloading:WithError:)]) {
        [self.delegate DownloadingTaskDidFailedDownloading:self WithError:error];
    }
}

- (void)notifyFinishedWithRegion:(TYBeaconRegion *)region WithBeacons:(NSArray *)beaconArray
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DownloadingTaskDidFinished:WithRegion:WithBeacons:)]) {
        [self.delegate DownloadingTaskDidFinished:self WithRegion:region WithBeacons:beaconArray];
    }
}

- (void)RegionBeaconDownloader:(IPRegionBeaconDownloader *)downloader DidFinishDownloadingWithRegion:(TYBeaconRegion *)region WithBeacons:(NSArray *)beacons
{
    [self notifyFinishedWithRegion:region WithBeacons:beacons];
}

- (void)RegionBeaconDownloader:(IPRegionBeaconDownloader *)downloader DidFinishDownloadingWithApi:(NSString *)api WithResult:(NSArray *)resultArray Records:(int)records
{
    
}

- (void)RegionBeaconDownloader:(IPRegionBeaconDownloader *)downloader DidFailedDownloadingWithApi:(NSString *)api WithError:(NSError *)error
{
    [self notifyFailedDownloadingWithError:error];
}

@end
