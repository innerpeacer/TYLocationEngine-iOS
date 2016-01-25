//
//  IPBLESyncDataManager.h
//  BLEProject
//
//  Created by innerpeacer on 16/1/3.
//  Copyright © 2016年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TYMapSDK/TYMapSDK.h>

@class IPBLESyncDataManager;
@class TYBeaconRegion;

@protocol IPBLESyncDataManagerDelegate <NSObject>

- (void)SyncDataManagerDidFinishSyncData:(IPBLESyncDataManager *)manager;
- (void)SyncDataManagerDidFinishDownloadingSyncData:(IPBLESyncDataManager *)manager;
- (void)SyncDataManagerDidFetchBeaconRegion:(TYBeaconRegion *)region;
@optional
- (void)SyncDataManagerDidFailedSyncData:(IPBLESyncDataManager *)manager InStep:(int)step WithError:(NSError *)error;

@end

@interface IPBLESyncDataManager : NSObject

@property (nonatomic, weak) id<IPBLESyncDataManagerDelegate> delegate;

- (id)initWithBuilding:(TYBuilding *)building User:(TYMapCredential *)user RootDirectory:(NSString *)root;
- (void)fetchData;

@end
