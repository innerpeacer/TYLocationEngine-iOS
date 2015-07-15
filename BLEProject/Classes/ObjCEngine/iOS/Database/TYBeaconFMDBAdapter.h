// Using FMDatabase for Operating database

#import <Foundation/Foundation.h>
#import "TYPublicBeacon.h"
#import <TYMapSDK/TYMapSDK.h>

@interface TYBeaconFMDBAdapter : NSObject

- (id)initWithBuilding:(TYBuilding *)building;

#pragma mark Database Operation
- (BOOL)open;
- (BOOL)close;

- (BOOL)deleteNephogramBeacon:(TYBeacon *)beacon;
- (BOOL)deleteNephogramBeaconWithMajor:(int)major Minor:(int)minor;
- (BOOL)eraseNephogramBeaconTable;

- (BOOL)insertNephogramBeacon:(TYPublicBeacon *)beacon;
- (BOOL)updateNephogramBeacon:(TYPublicBeacon *)beacon;
- (BOOL)updateNephogramBeacon:(TYBeacon *)beacon WithLocation:(TYLocalPoint *)lp ShopGid:(NSString *)shopID;

- (NSArray *)getAllNephogramBeacons;
- (TYPublicBeacon *)getNephogramBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor;

@end