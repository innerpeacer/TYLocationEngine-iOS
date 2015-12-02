#import "TYPublicBeacon.h"
#import "TYPointConverter.h"

#define FIELD_BEACON_1_GEOM @"GEOM"
#define FIELD_BEACON_2_UUID @"UUID"
#define FIELD_BEACON_3_MAJOR @"MAJOR"
#define FIELD_BEACON_4_MINOR @"MINOR"
#define FIELD_BEACON_5_FLOOR @"FLOOR"
#define FIELD_BEACON_6_X @"X"
#define FIELD_BEACON_7_Y @"Y"
#define FIELD_BEACON_8_ROOM_ID @"ROOM_ID"
#define FIELD_BEACON_9_TAG @"TAG"

#define FIELD_BEACON_10_MAP_ID @"MAP_ID"
#define FIELD_BEACON_11_BUILDING_ID @"BUILDING_ID"
#define FIELD_BEACON_12_CITY_ID @"CITY_ID"


@implementation TYPublicBeacon

+ (TYPublicBeacon *)beaconWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag Location:(TYLocalPoint *)location
{
    return [[TYPublicBeacon alloc] initWithUUID:uuid Major:major Minor:minor Tag:tag Location:location];
}

+ (TYPublicBeacon *)beaconWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag Location:(TYLocalPoint *)location ShopGid:(NSString *)shopID
{
    TYPublicBeacon *beacon = [[TYPublicBeacon alloc] initWithUUID:uuid Major:major Minor:minor Tag:tag Location:location];
    beacon.shopGid = shopID;
    return beacon;
}

- (id)initWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag Location:(TYLocalPoint *)location
{
    self = [super initWithUUID:uuid Major:major Minor:minor Tag:tag Type:PUBLIC];
    if (self) {
        _location = location;
    }
    return self;
}

- (id)initWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag Type:(TYPE)type
{
    return [super initWithUUID:uuid Major:major Minor:minor Tag:tag Type:PUBLIC];
}

+ (NSDictionary *)buildBeaconObject:(TYPublicBeacon *)pb
{
    NSMutableDictionary *beaconObject = [NSMutableDictionary dictionary];
    
    NSData *geometryData = [TYPointConverter dataFromX:pb.location.x Y:pb.location.y Z:0];
    NSString *geometryEncode = [geometryData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    [beaconObject setObject:geometryEncode forKey:FIELD_BEACON_1_GEOM];
    [beaconObject setObject:pb.UUID forKey:FIELD_BEACON_2_UUID];
    [beaconObject setObject:pb.major forKey:FIELD_BEACON_3_MAJOR];
    [beaconObject setObject:pb.minor forKey:FIELD_BEACON_4_MINOR];
    [beaconObject setObject:@(pb.location.floor) forKey:FIELD_BEACON_5_FLOOR];
    [beaconObject setObject:@(pb.location.x) forKey:FIELD_BEACON_6_X];
    [beaconObject setObject:@(pb.location.y) forKey:FIELD_BEACON_7_Y];
    if (pb.shopGid) {
        [beaconObject setObject:pb.shopGid forKey:FIELD_BEACON_8_ROOM_ID];
    }
    if (pb.tag) {
        [beaconObject setObject:pb.tag forKey:FIELD_BEACON_9_TAG];
    }
    [beaconObject setObject:pb.mapID forKey:FIELD_BEACON_10_MAP_ID];
    [beaconObject setObject:pb.buildingID forKey:FIELD_BEACON_11_BUILDING_ID];
    [beaconObject setObject:pb.cityID forKey:FIELD_BEACON_12_CITY_ID];
    
    return beaconObject;
}

+ (TYPublicBeacon *)parseBeaconObject:(NSDictionary *)beaconObject
{
    NSString *uuid = beaconObject[FIELD_BEACON_2_UUID];
    NSNumber *major = beaconObject[FIELD_BEACON_3_MAJOR];
    NSNumber *minor = beaconObject[FIELD_BEACON_4_MINOR];
    
    double x = [beaconObject[FIELD_BEACON_6_X] doubleValue];
    double y = [beaconObject[FIELD_BEACON_7_Y] doubleValue];
    int floor = [beaconObject[FIELD_BEACON_5_FLOOR] intValue];
    
    NSString *tag = beaconObject[FIELD_BEACON_9_TAG];
    
    TYLocalPoint *location = [TYLocalPoint pointWithX:x Y:y Floor:floor];
    TYPublicBeacon *pb = [TYPublicBeacon beaconWithUUID:uuid Major:major Minor:minor Tag:tag Location:location];
    return pb;
}


- (NSString *)description
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"Public Beacon-Major: %@, Minor: %@ Tag: %@", self.major, self.minor, self.tag];
    if (self.location) {
        [str appendFormat:@", Location: %@", self.location];
    }
    
    if (self.shopGid) {
        [str appendFormat:@", ShopID: %@", self.shopGid];
    }
    return str;
}

@end

