//
//  IPRegionBeaconUploader.m
//  BLEProject
//
//  Created by innerpeacer on 15/12/29.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "IPRegionBeaconUploader.h"
#import "IPBLEWebUploader.h"
#import "IPBLEWebObjectConverter.h"


@interface IPRegionBeaconUploader() <IPBLEWebUploaderDelegate>
{
    TYMapCredential *user;
    IPBLEWebUploader *uploader;
}

@end

@implementation IPRegionBeaconUploader

- (id)initWithUser:(TYMapCredential *)u
{
    self = [super init];
    if (self) {
        user = u;
        
        NSString *hostName = [TYMapEnvironment getHostName];
        NSAssert(hostName != nil, @"Host Name must not be nil!");
        
        uploader = [[IPBLEWebUploader alloc] initWithHostName:hostName];
        uploader.delegate = self;
    }
    return self;
}

- (void)uploadBeaconRegions:(NSArray *)regions
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"userID"] = user.userID;
    param[@"regions"] = [IPBLEWebObjectConverter prepareJsonString:[IPBLEWebObjectConverter prepareBeaconRegionObjectArray:regions]];
    [uploader uploadWithApi:TY_API_UPLOAD_ALL_BEACON_REGIONS Parameters:param];
}

- (void)addBeaconRegion:(NSArray *)regions
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"userID"] = user.userID;
    param[@"regions"] = [IPBLEWebObjectConverter prepareJsonString:[IPBLEWebObjectConverter prepareBeaconRegionObjectArray:regions]];
    [uploader uploadWithApi:TY_API_ADD_BEACON_REGION Parameters:param];
}

- (void)uploadLocatingBeacons:(NSArray *)beacons
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"userID"] = user.userID;
    param[@"buildingID"] = user.buildingID;
    param[@"license"] = user.license;
    [param setValue:[IPBLEWebObjectConverter prepareJsonString:[IPBLEWebObjectConverter prepareBeaconObjectArray:beacons]] forKey:@"beacons"];
    [uploader uploadWithApi:TY_API_UPLOAD_LOCATING_BEACONS Parameters:param];
}

- (void)uploadLocatingBeacons:(NSArray *)beacons AndBeaconRegion:(TYBeaconRegion *)region
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"userID"] = user.userID;
    param[@"buildingID"] = user.buildingID;
    param[@"license"] = user.license;
    param[@"beacons"] = [IPBLEWebObjectConverter prepareJsonString:[IPBLEWebObjectConverter prepareBeaconObjectArray:beacons]];
    param[@"regions"] = [IPBLEWebObjectConverter prepareJsonString:[IPBLEWebObjectConverter prepareBeaconRegionObjectArray:@[region]]];
    [uploader uploadWithApi:TY_API_ADD_REGION_AND_BEACONS Parameters:param];
}

- (void)WebUploaderDidFailedUploading:(IPBLEWebUploader *)uploader WithApi:(NSString *)api WithError:(NSError *)error
{
    [self notifyFailedUploadingWithApi:api WithError:error];
}

- (void)WebUploaderDidFinishUploading:(IPBLEWebUploader *)uploader WithApi:(NSString *)api WithResponseData:(NSData *)responseData ResponseString:(NSString *)responseString
{
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        [self notifyFailedUploadingWithApi:api WithError:error];
        return;
    }
    
    BOOL success = [resultDict[TY_RESPONSE_STATUS] boolValue];
    NSString *description = resultDict[TY_RESPONSE_DESCRIPTION];
    
    if (success) {
        int records = [resultDict[TY_RESPONSE_RECORDS] intValue];
        NSLog(@"Upload: %d", records);
        [self notifyUploadingWithApi:api WithDescription:description];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:@"com.ty.ble" code:0 userInfo:userInfo];
        [self notifyFailedUploadingWithApi:api WithError:error];
    }
}

- (void)notifyUploadingWithApi:(NSString *)api WithDescription:(NSString *)description
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RegionBeaconUploader:DidFinishUploadingWithApi:WithDescription:)]) {
        [self.delegate RegionBeaconUploader:self DidFinishUploadingWithApi:api WithDescription:description];
    }
}

- (void)notifyFailedUploadingWithApi:(NSString *)api WithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RegionBeaconUploader:DidFailedUploadingWithApi:WithError:)]) {
        [self.delegate RegionBeaconUploader:self DidFailedUploadingWithApi:api WithError:error];
    }
}
@end
