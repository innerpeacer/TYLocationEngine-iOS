#import "TYRegionManager.h"
#import "AppConstants.h"

@implementation TYRegionManager

static NSUUID *_defaultUUID;
static CLBeaconRegion *_defaultRegion;

+ (NSUUID *)defaultUUID
{
    if (_defaultUUID == nil) {
        _defaultUUID = [[NSUUID alloc] initWithUUIDString:BEACON_SERVICE_UUID];
    }
    return _defaultUUID;
}

+ (CLBeaconRegion *)defaultRegion
{
    if (_defaultRegion == nil) {
//        _defaultRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[TYRegionManager defaultUUID] major:BEACON_REGION_MAJOR identifier:BEACON_REGION_IDENTIFIER];
        _defaultRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[TYRegionManager defaultUUID] identifier:BEACON_REGION_IDENTIFIER];
    }
    return _defaultRegion;
}

@end
