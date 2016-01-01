#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "TYBeaconRegion.h"

@interface TYRegionManager : NSObject

+ (TYBeaconRegion *)getBeaconRegionForBuilding:(NSString *)buildingID;
+ (NSArray *)getAllBeaconRegions;
+ (void)reloadRegions;

@end
