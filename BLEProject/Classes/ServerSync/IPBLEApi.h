//
//  IPBLEApi.h
//  BLEProject
//
//  Created by innerpeacer on 15/12/29.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#ifndef IPBLEApi_h
#define IPBLEApi_h

#pragma mark -
#pragma mark User API
#define TY_API_GET_ALL_BEACON_REGIONS               @"/TYMapServerManager/user/ble/GetAllBeaconRegions"
#define TY_API_GET_TARGET_LOCATING_BEACONS          @"/TYMapServerManager/user/ble/GetLocatingBeacons"
#define TY_API_GET_TARGET_BEACON_REGION             @"/TYMapServerManager/user/ble/GetBeaconRegion"
#define TY_API_GET_TARGET_REGION_AND_BEACON         @"/TYMapServerManager/user/ble/GetRegionAndBeacon"

#pragma mark -
#pragma mark Response
#define TY_RESPONSE_STATUS @"success"
#define TY_RESPONSE_DESCRIPTION @"description"
#define TY_RESPONSE_RECORDS @"records"

#endif /* IPBLEApi_h */
