#import <Foundation/Foundation.h>
#import "NPPublicBeacon.h"

@interface NPXBeaconDBAdapter : NSObject

- (id)initWithDBFile:(NSString *)path;

#pragma mark Database Operation
- (BOOL)open;
- (BOOL)close;

- (NSArray *)getAllNephogramBeacons;
- (NPPublicBeacon *)getNephogramBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor;

@end
