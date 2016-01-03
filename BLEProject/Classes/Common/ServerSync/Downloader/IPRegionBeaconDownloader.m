//
//  IPRegionBeaconDownloader.m
//  BLEProject
//
//  Created by innerpeacer on 15/12/29.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "IPRegionBeaconDownloader.h"
#import "IPBLEWebDownloader.h"
#import "IPBLEWebObjectConverter.h"

@interface IPRegionBeaconDownloader() <IPBLEWebDownloaderDelegate>
{
    TYMapCredential *user;
    IPBLEWebDownloader *downloader;
}

@end

@implementation IPRegionBeaconDownloader

- (id)initWithUser:(TYMapCredential *)u
{
    self = [super init];
    if (self) {
        user = u;
        
        NSString *hostName = [TYMapEnvironment getHostName];
        NSAssert(hostName != nil, @"Host Name must not be nil!");
        
        downloader = [[IPBLEWebDownloader alloc] initWithHostName:hostName];
        downloader.delegate = self;
    }
    return self;
}

- (void)getAllBeaconRegions
{
    [downloader downloadWithApi:TY_API_GET_ALL_BEACON_REGIONS Parameters:[user buildDictionary]];
}

- (void)getBeaconRegion
{
    [downloader downloadWithApi:TY_API_GET_TARGET_BEACON_REGION Parameters:[user buildDictionary]];
}

- (void)getLocatingBeacons
{
    [downloader downloadWithApi:TY_API_GET_TARGET_LOCATING_BEACONS Parameters:[user buildDictionary]];
}

- (void)getRegionAndBeacons
{
    [downloader downloadWithApi:TY_API_GET_TARGET_REGION_AND_BEACON Parameters:[user buildDictionary]];
}


- (void)WebDownloaderDidFinishDownloading:(IPBLEWebDownloader *)downloader WithApi:(NSString *)api WithResponseData:(NSData *)responseData ResponseString:(NSString *)responseString
{
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        [self notifyFailedDownloadingWithApi:api WithError:error];
        return;
    }
    
    BOOL success = [resultDict[TY_RESPONSE_STATUS] boolValue];
    NSString *description = resultDict[TY_RESPONSE_DESCRIPTION];
    int records = [resultDict[TY_RESPONSE_RECORDS] intValue];
    
    if (success) {
        if ([api isEqualToString:TY_API_GET_ALL_BEACON_REGIONS] || [api isEqualToString:TY_API_GET_TARGET_BEACON_REGION]) {
            NSArray *regionArray = [IPBLEWebObjectConverter parseBeaconRegionArray:resultDict[@"regions"]];
            [self notifyDownloadingWithApi:api WithResult:regionArray Records:records];
        }
        
        if ([api isEqualToString:TY_API_GET_TARGET_LOCATING_BEACONS]) {
            NSArray *beaconArray = [IPBLEWebObjectConverter parseBeaconArray:resultDict[@"beacons"]];
            [self notifyDownloadingWithApi:api WithResult:beaconArray Records:records];
        }
        
        if ([api isEqualToString:TY_API_GET_TARGET_REGION_AND_BEACON]) {
            NSArray *regionArray = [IPBLEWebObjectConverter parseBeaconRegionArray:resultDict[@"regions"]];
            NSArray *beaconArray = [IPBLEWebObjectConverter parseBeaconArray:resultDict[@"beacons"]];
            
            TYBeaconRegion *region = nil;
            if (regionArray && regionArray.count > 0) {
                region = regionArray[0];
            }
            
            [self notifyDownloadingWithRegion:region WithBeacons:beaconArray];
        }
        
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:description                                                                     forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:@"com.ty.ble" code:0 userInfo:userInfo];
        [self notifyFailedDownloadingWithApi:api WithError:error];
    }
}

- (void)WebDownloaderDidFailedDownloading:(IPBLEWebDownloader *)downloader WithApi:(NSString *)api WithError:(NSError *)error
{
    [self notifyFailedDownloadingWithApi:api WithError:error];
}

- (void)notifyDownloadingWithRegion:(TYBeaconRegion *)region WithBeacons:(NSArray *)beacons
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RegionBeaconDownloader:DidFinishDownloadingWithRegion:WithBeacons:)]) {
        [self.delegate RegionBeaconDownloader:self DidFinishDownloadingWithRegion:region WithBeacons:beacons];
    }
}

- (void)notifyDownloadingWithApi:(NSString *)api WithResult:(NSArray *)resultArray Records:(int)records
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RegionBeaconDownloader:DidFinishDownloadingWithApi:WithResult:Records:)]) {
        [self.delegate RegionBeaconDownloader:self DidFinishDownloadingWithApi:api WithResult:resultArray Records:records];
    }
}

- (void)notifyFailedDownloadingWithApi:(NSString *)api WithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RegionBeaconDownloader:DidFailedDownloadingWithApi:WithError:)]) {
        [self.delegate RegionBeaconDownloader:self DidFailedDownloadingWithApi:api WithError:error];
    }
}

@end
