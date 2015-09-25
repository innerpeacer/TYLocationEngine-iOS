// Using FMDatabase for Operating database

#import <Foundation/Foundation.h>
#import "TYPublicBeacon.h"
#import <TYMapSDK/TYMapSDK.h>

@interface TYBeaconFMDBAdapter : NSObject

- (id)initWithBuilding:(TYBuilding *)building;

#pragma mark Database Operation
- (BOOL)open;
- (BOOL)close;

- (BOOL)deleteLocationingBeacon:(TYBeacon *)beacon;
- (BOOL)deleteLocationingBeaconWithMajor:(int)major Minor:(int)minor;
- (BOOL)eraseLocationingBeaconTable;

- (BOOL)insertLocationingBeacon:(TYPublicBeacon *)beacon;
- (BOOL)updateLocationingBeacon:(TYPublicBeacon *)beacon;
- (BOOL)updateLocationingBeacon:(TYBeacon *)beacon WithLocation:(TYLocalPoint *)lp ShopGid:(NSString *)shopID;

- (NSArray *)getAllLocationingBeacons;
- (TYPublicBeacon *)getLocationingBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor;

- (BOOL)insertCheckCode:(NSString *)code;
- (BOOL)updateCheckCode:(NSString *)code;
- (BOOL)eraseCheckCodeTable;
- (NSString *)getCheckCode;

@end