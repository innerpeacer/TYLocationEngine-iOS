//
//  IPBLESyncDataManager.m
//  BLEProject
//
//  Created by innerpeacer on 16/1/3.
//  Copyright © 2016年 innerpeacer. All rights reserved.
//

#import "IPBLESyncDataManager.h"
#import "IPBLESyncDownloadingTask.h"
#import "IPSyncBeaconDBAdapter.h"
#import "IPBeaconDBCodeChecker.h"

@interface IPBLESyncDataManager() <IPBLESyncDownloadingTaskDelegate>
{
    TYBuilding *currentBuilding;
    NSString *rootDir;
    TYMapCredential *mapUser;
    
    IPBLESyncDownloadingTask *downloadingTask;
}

@end

@implementation IPBLESyncDataManager

- (id)initWithBuilding:(TYBuilding *)building User:(TYMapCredential *)user RootDirectory:(NSString *)root
{
    self = [super init];
    if (self) {
        currentBuilding = building;
        mapUser = user;
        rootDir = root;
        
        downloadingTask = [[IPBLESyncDownloadingTask alloc] initWithUser:user];
        downloadingTask.delegate = self;
    }
    return self;
}

- (void)fetchData
{
    [downloadingTask featchData];
}

- (void)checkDir:(TYBuilding *)b
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *cityDir = [rootDir stringByAppendingPathComponent:b.cityID];
    NSString *buildingDir = [cityDir stringByAppendingPathComponent:b.buildingID];
    if (![manager fileExistsAtPath:buildingDir]) {
        NSError *error = nil;
        [manager createDirectoryAtPath:buildingDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
}

- (NSString *)getBeaconDBPath:(TYBuilding *)b
{
    return [[[rootDir stringByAppendingPathComponent:b.cityID] stringByAppendingPathComponent:b.buildingID] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_Beacon.db", b.buildingID]];
}



- (void)DownloadingTaskDidFailedDownloading:(IPBLESyncDownloadingTask *)task WithError:(NSError *)error
{
    [self notifyFailedInStep:1 WithError:error];
}

- (void)DownloadingTaskDidFinished:(IPBLESyncDownloadingTask *)task WithRegion:(TYBeaconRegion *)region WithBeacons:(NSArray *)beaconArray
{
    NSLog(@"Finish Downloading");

    [self notifyFinishDownloading];
    
    [self checkDir:currentBuilding];
    
    IPSyncBeaconDBAdapter *beaconDB = [[IPSyncBeaconDBAdapter alloc] initWithPath:[self getBeaconDBPath:currentBuilding]];
    [beaconDB open];
    [beaconDB eraseCheckCodeTable];
    [beaconDB eraseLocatingBeaconTable];
    
    [beaconDB insertLocatingBeacons:beaconArray];
    
    NSString *code = [IPBeaconDBCodeChecker checkBeacons:beaconArray];
    [beaconDB insertCheckCode:code];
    
    [beaconDB close];
    
    [self notifyFinishSyncData];
    [self notifyFetchRegion:region];
}

- (void)notifyFinishSyncData
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SyncDataManagerDidFinishSyncData:)]) {
        [self.delegate SyncDataManagerDidFinishSyncData:self];
    }
}

- (void)notifyFinishDownloading
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SyncDataManagerDidFinishDownloadingSyncData:)]) {
        [self.delegate SyncDataManagerDidFinishDownloadingSyncData:self];
    }
}

- (void)notifyFetchRegion:(TYBeaconRegion *)region
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SyncDataManagerDidFetchBeaconRegion:)]) {
        [self.delegate SyncDataManagerDidFetchBeaconRegion:region];
    }
}

- (void)notifyFailedInStep:(int)step WithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SyncDataManagerDidFailedSyncData:InStep:WithError:)]) {
        [self.delegate SyncDataManagerDidFailedSyncData:self InStep:step WithError:error];
    }
}

@end
