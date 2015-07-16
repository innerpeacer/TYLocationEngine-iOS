#import <Foundation/Foundation.h>
#import "TYPublicBeacon.h"

@interface IPXBeaconDBAdapter : NSObject

- (id)initWithDBFile:(NSString *)path;

#pragma mark Database Operation
- (BOOL)open;
- (BOOL)close;

- (NSArray *)getAllLocationingBeacons;
- (TYPublicBeacon *)getLocationingBeaconWithMajor:(NSNumber *)major Minor:(NSNumber *)minor;

@end
