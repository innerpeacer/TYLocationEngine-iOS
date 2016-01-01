#import "TYRegionManager.h"

#define KEY_BEACON_REGION @"BeaconRegion"
#define KEY_CITY_ID @"cityID"
#define KEY_BUILDING_ID @"buildingID"
#define KEY_NAME @"name"
#define KEY_UUID @"uuid"
#define KEY_MAJOR @"major"

#import "TYBeaconRegionDBAdapter.h"
#import <TYMapSDK/TYMapSDK.h>

@implementation TYRegionManager

static NSDictionary *allBeaconRegionDictionary;

+ (CLBeaconRegion *)getBeaconRegionForBuilding:(NSString *)building
{
    if (allBeaconRegionDictionary == nil) {
        NSString *path = [[TYMapEnvironment getRootDirectoryForMapFiles] stringByAppendingPathComponent:@"BeaconRegion.db"];
        allBeaconRegionDictionary = [TYRegionManager parseAllBeaconRegion:path];
    }
    return [allBeaconRegionDictionary objectForKey:building];
}

+ (NSArray *)getAllBeaconRegions
{
    if (allBeaconRegionDictionary == nil) {
        NSString *path = [[TYMapEnvironment getRootDirectoryForMapFiles] stringByAppendingPathComponent:@"BeaconRegion.db"];
        allBeaconRegionDictionary = [TYRegionManager parseAllBeaconRegion:path];
    }
    return [allBeaconRegionDictionary allValues];
}

+ (void)reloadRegions
{
    NSString *path = [[TYMapEnvironment getRootDirectoryForMapFiles] stringByAppendingPathComponent:@"BeaconRegion.db"];
    allBeaconRegionDictionary = [TYRegionManager parseAllBeaconRegion:path];
}

+ (NSDictionary *)parseAllBeaconRegion:(NSString *)path
{
    NSMutableDictionary *allDict = [NSMutableDictionary dictionary];
    
    TYBeaconRegionDBAdapter *db = [[TYBeaconRegionDBAdapter alloc] initWithPath:path];
    [db open];
    NSArray *regionArray = [db getAllBeaconRegions];
    for (TYBeaconRegion *region in regionArray) {
        [allDict setObject:region forKey:region.buildingID];
    }
    [db close];
    return allDict;
}

@end
