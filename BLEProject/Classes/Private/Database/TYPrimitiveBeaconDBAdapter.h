#import <Foundation/Foundation.h>
#import "TYBeacon.h"
#import <TYMapSDK/TYMapSDK.h>

@interface TYPrimitiveBeaconDBAdapter : NSObject

- (id)initWithBuilding:(TYBuilding *)building;

#pragma mark Database Operation
- (BOOL)open;
- (BOOL)close;

#pragma mark primitive beacon
- (BOOL)deletePrimitiveBeacon:(TYBeacon *)beacon;
- (BOOL)deletePrimitiveBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor;
- (BOOL)erasePrimitiveBeaconTable;

- (BOOL)insertPrimitiveBeacon:(TYBeacon *)beacon;
- (BOOL)insertPrimitiveBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag;

- (BOOL)updatePrimitiveBeacon:(TYBeacon *)beacon;
- (BOOL)updatePrimitiveBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag;

- (NSArray *)getAllPrimitiveBeacons;
- (TYBeacon *)getPrimitiveBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor;
- (TYBeacon *)getPrimitiveBeaconWithTag:(NSString *)tag;

@end
