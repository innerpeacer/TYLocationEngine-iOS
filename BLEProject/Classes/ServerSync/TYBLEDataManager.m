//
//  TYBLEDataManager.m
//  BLEProject
//
//  Created by innerpeacer on 16/1/4.
//  Copyright © 2016年 innerpeacer. All rights reserved.
//

#import "TYBLEDataManager.h"
#import "IPBLESyncDataManager.h"


@interface TYBLEDataManager() <IPBLESyncDataManagerDelegate>
{
    IPBLESyncDataManager *syncManager;
    TYMapCredential *mapCredential;
    
    TYBuilding *currentBuilding;
}

@end

@implementation TYBLEDataManager

- (id)initWithUserID:(NSString *)userID Building:(TYBuilding *)building License:(NSString *)license
{
    self = [super init];
    if (self) {
        mapCredential = [TYMapCredential credentialWithUserID:userID BuildingID:building.buildingID License:license];
        syncManager = [[IPBLESyncDataManager alloc] initWithBuilding:building User:mapCredential RootDirectory:[TYMapEnvironment getRootDirectoryForMapFiles]];
        syncManager.delegate = self;
    }
    return self;
}

- (void)fetchLocatingData
{
    [syncManager fetchData];
}

- (void)SyncDataManagerDidFailedSyncData:(IPBLESyncDataManager *)manager InStep:(int)step WithError:(NSError *)error
{
    [self notifyFailedFetchingData:error];
}

- (void)SyncDataManagerDidFinishDownloadingSyncData:(IPBLESyncDataManager *)manager
{
    
}

- (void)SyncDataManagerDidFetchBeaconRegion:(TYBeaconRegion *)region
{
    [self notifyFetchRegion:region];
}

- (void)SyncDataManagerDidFinishSyncData:(IPBLESyncDataManager *)manager
{
    [self notifyFinishFetchingData];
}

- (void)notifyFetchRegion:(TYBeaconRegion *)region
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TYBLEDataManagerDidFetchBeaconRegion:)]) {
        [self.delegate TYBLEDataManagerDidFetchBeaconRegion:region];
    }
}

- (void)notifyFinishFetchingData
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TYBLEDataManagerDidFinishFetchingData:)]) {
        [self.delegate TYBLEDataManagerDidFinishFetchingData:self];
    }
}

- (void)notifyFailedFetchingData:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TYBLEDataManagerDidFailedFetchingData:WithError:)]) {
        [self.delegate TYBLEDataManagerDidFailedFetchingData:self WithError:error];
    }
}

@end
