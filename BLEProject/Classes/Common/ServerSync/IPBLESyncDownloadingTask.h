//
//  IPBLESyncDownloadingTask.h
//  BLEProject
//
//  Created by innerpeacer on 16/1/3.
//  Copyright © 2016年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYBeaconRegion.h"
#import <TYMapSDK/TYMapSDK.h>

@class IPBLESyncDownloadingTask;

@protocol IPBLESyncDownloadingTaskDelegate <NSObject>

- (void)DownloadingTaskDidFinished:(IPBLESyncDownloadingTask *)task WithRegion:(TYBeaconRegion *)region WithBeacons:(NSArray *)beaconArray;
- (void)DownloadingTaskDidFailedDownloading:(IPBLESyncDownloadingTask *)task WithError:(NSError *)error;

@end

@interface IPBLESyncDownloadingTask : NSObject

@property (nonatomic, weak) id<IPBLESyncDownloadingTaskDelegate> delegate;

- (id)initWithUser:(TYMapCredential *)u;
- (void)featchData;
@end
