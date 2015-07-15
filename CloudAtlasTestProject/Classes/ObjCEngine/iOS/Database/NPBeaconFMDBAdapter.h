// Using FMDatabase for Operating database

#import <Foundation/Foundation.h>
#import "NPPublicBeacon.h"
#import <TYMapSDK/TYMapSDK.h>

@interface NPBeaconFMDBAdapter : NSObject

- (id)initWithBuilding:(TYBuilding *)building;

#pragma mark Database Operation
- (BOOL)open;
- (BOOL)close;

- (BOOL)deleteNephogramBeacon:(NPBeacon *)beacon;
- (BOOL)deleteNephogramBeaconWithMajor:(int)major Minor:(int)minor;
- (BOOL)eraseNephogramBeaconTable;

- (BOOL)insertNephogramBeacon:(NPPublicBeacon *)beacon;
- (BOOL)updateNephogramBeacon:(NPPublicBeacon *)beacon;
- (BOOL)updateNephogramBeacon:(NPBeacon *)beacon WithLocation:(TYLocalPoint *)lp ShopGid:(NSString *)shopID;

- (NSArray *)getAllNephogramBeacons;
- (NPPublicBeacon *)getNephogramBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor;

@end