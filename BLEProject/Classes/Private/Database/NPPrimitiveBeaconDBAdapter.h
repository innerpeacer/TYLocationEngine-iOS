#import <Foundation/Foundation.h>
#import "NPBeacon.h"
#import <TYMapSDK/TYMapSDK.h>

@interface NPPrimitiveBeaconDBAdapter : NSObject

- (id)initWithBuilding:(TYBuilding *)building;

#pragma mark Database Operation
- (BOOL)open;
- (BOOL)close;

#pragma mark primitive beacon
- (BOOL)deletePrimitiveBeacon:(NPBeacon *)beacon;
- (BOOL)deletePrimitiveBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor;
- (BOOL)erasePrimitiveBeaconTable;

- (BOOL)insertPrimitiveBeacon:(NPBeacon *)beacon;
- (BOOL)insertPrimitiveBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag;

- (BOOL)updatePrimitiveBeacon:(NPBeacon *)beacon;
- (BOOL)updatePrimitiveBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag;

- (NSArray *)getAllPrimitiveBeacons;
- (NPBeacon *)getPrimitiveBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor;
- (NPBeacon *)getPrimitiveBeaconWithTag:(NSString *)tag;

@end

