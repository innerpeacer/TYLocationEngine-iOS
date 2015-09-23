#import "TYRegionManager.h"

#define KEY_BEACON_REGION @"BeaconRegion"
#define KEY_CITY_ID @"cityID"
#define KEY_BUILDING_ID @"buildingID"
#define KEY_NAME @"name"
#define KEY_UUID @"uuid"
#define KEY_MAJOR @"major"



@implementation TYRegionManager

static NSDictionary *allBeaconRegionDictionary;

+ (CLBeaconRegion *)getBeaconRegionForBuilding:(NSString *)building
{
    if (allBeaconRegionDictionary == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"BeaconRegion" ofType:@"json"];
        allBeaconRegionDictionary = [TYRegionManager parseAllBeaconRegion:path];
    }
    
    TYBeaconRegion *br = [allBeaconRegionDictionary objectForKey:building];
    if (br) {
        return br.region;
    }
    return nil;
}

+ (NSDictionary *)parseAllBeaconRegion:(NSString *)path
{
    NSMutableDictionary *allDict = [NSMutableDictionary dictionary];
    
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *regionDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        
        NSArray *regionArray = [regionDict objectForKey:KEY_BEACON_REGION];
        for (NSDictionary *dict in regionArray) {
            NSString *cityID = [dict objectForKey:KEY_CITY_ID];
            NSString *buildingID = [dict objectForKey:KEY_BUILDING_ID];
            NSString *name = [dict objectForKey:KEY_NAME];
            NSString *uuidString = [dict objectForKey:KEY_UUID];
            NSNumber *majorNumber = [dict objectForKey:KEY_MAJOR];
            
            TYBeaconRegion *beaconRegion = [[TYBeaconRegion alloc] init];
            beaconRegion.cityID = cityID;
            beaconRegion.buildingID = buildingID;
            beaconRegion.name = name;
            
            if ((NSNull *)majorNumber == [NSNull null]) {
                beaconRegion.region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuidString] identifier:@""];
            } else {
                beaconRegion.region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuidString] major:majorNumber.intValue identifier:@""];
            }
            
            [allDict setObject:beaconRegion forKey:beaconRegion.buildingID];
        }
    }
    return allDict;
}

@end

