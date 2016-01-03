//
//  IPSyncBeaconDBAdapter.h
//  BLEProject
//
//  Created by innerpeacer on 16/1/3.
//  Copyright © 2016年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYPublicBeacon.h"

@interface IPSyncBeaconDBAdapter : NSObject

- (id)initWithPath:(NSString *)path;

- (BOOL)open;
- (BOOL)close;

- (BOOL)deleteLocatingBeacon:(TYBeacon *)beacon;
- (BOOL)deleteLocatingBeaconWithMajor:(int)major Minor:(int)minor;
- (BOOL)eraseLocatingBeaconTable;

- (BOOL)insertLocatingBeacon:(TYPublicBeacon *)beacon;
- (int)insertLocatingBeacons:(NSArray *)beaconArray;
- (BOOL)updateLocatingBeacon:(TYPublicBeacon *)beacon;
- (BOOL)updateLocatingBeacon:(TYBeacon *)beacon WithLocation:(TYLocalPoint *)lp ShopGid:(NSString *)shopID;

- (NSArray *)getAllLocatingBeacons;
- (TYPublicBeacon *)getLocatingBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor;

- (BOOL)insertCheckCode:(NSString *)code;
- (BOOL)updateCheckCode:(NSString *)code;
- (BOOL)eraseCheckCodeTable;
- (NSString *)getCheckCode;

@end
