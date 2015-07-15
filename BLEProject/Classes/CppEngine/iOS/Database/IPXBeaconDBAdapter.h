#import <Foundation/Foundation.h>
#import "TYPublicBeacon.h"

@interface IPXBeaconDBAdapter : NSObject

- (id)initWithDBFile:(NSString *)path;

#pragma mark Database Operation
- (BOOL)open;
- (BOOL)close;

- (NSArray *)getAllNephogramBeacons;
- (TYPublicBeacon *)getNephogramBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor;

@end
