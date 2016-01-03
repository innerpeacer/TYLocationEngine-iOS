//
//  IPRegionBeaconDownloader.h
//  BLEProject
//
//  Created by innerpeacer on 15/12/29.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TYMapSDK/TYMapSDK.h>
#import "TYBeaconRegion.h"

@class IPRegionBeaconDownloader;

@protocol IPRegionBeaconDownloaderDelegate <NSObject>

- (void)RegionBeaconDownloader:(IPRegionBeaconDownloader *)downloader DidFinishDownloadingWithApi:(NSString *)api WithResult:(NSArray *)resultArray Records:(int)records;
- (void)RegionBeaconDownloader:(IPRegionBeaconDownloader *)downloader DidFinishDownloadingWithRegion:(TYBeaconRegion *)region WithBeacons:(NSArray *)beacons;
- (void)RegionBeaconDownloader:(IPRegionBeaconDownloader *)downloader DidFailedDownloadingWithApi:(NSString *)api WithError:(NSError *)error;

@end

@interface IPRegionBeaconDownloader : NSObject

- (id)initWithUser:(TYMapCredential *)user;
@property (nonatomic, weak) id<IPRegionBeaconDownloaderDelegate> delegate;

- (void)getAllBeaconRegions;
- (void)getBeaconRegion;
- (void)getLocatingBeacons;
- (void)getRegionAndBeacons;

@end
