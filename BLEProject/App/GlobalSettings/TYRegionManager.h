#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "TYBeaconRegion.h"

@interface TYRegionManager : NSObject

+ (CLBeaconRegion *)getBeaconRegionForBuilding:(NSString *)buildingID;

@end
