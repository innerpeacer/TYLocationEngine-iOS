#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TYRegionManager : NSObject

+ (NSUUID *)defaultUUID;
+ (CLBeaconRegion *)defaultRegion;

@end
