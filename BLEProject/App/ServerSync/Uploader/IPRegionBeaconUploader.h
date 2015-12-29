//
//  IPRegionBeaconUploader.h
//  BLEProject
//
//  Created by innerpeacer on 15/12/29.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TYMapSDK/TYMapSDK.h>
#import "TYBeaconRegion.h"

@class IPRegionBeaconUploader;

@protocol IPRegionBeaconUploaderDelegate <NSObject>

- (void)RegionBeaconUploader:(IPRegionBeaconUploader *)uploader DidFinishUploadingWithApi:(NSString *)api WithDescription:(NSString *)description;
- (void)RegionBeaconUploader:(IPRegionBeaconUploader *)uploader DidFailedUploadingWithApi:(NSString *)api WithError:(NSError *)error;


@end

@interface IPRegionBeaconUploader : NSObject

- (id)initWithUser:(TYMapCredential *)user;
@property (nonatomic, weak) id<IPRegionBeaconUploaderDelegate> delegate;

- (void)uploadBeaconRegions:(NSArray *)regions;
- (void)addBeaconRegion:(NSArray *)regions;
- (void)uploadLocatingBeacons:(NSArray *)beacons;
- (void)uploadLocatingBeacons:(NSArray *)beacons AndBeaconRegion:(TYBeaconRegion *)region;

@end
