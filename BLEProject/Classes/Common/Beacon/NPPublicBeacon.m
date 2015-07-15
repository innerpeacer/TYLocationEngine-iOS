#import "NPPublicBeacon.h"

@implementation NPPublicBeacon

+ (NPPublicBeacon *)beaconWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag Location:(TYLocalPoint *)location
{
    return [[NPPublicBeacon alloc] initWithUUID:uuid Major:major Minor:minor Tag:tag Location:location];
}

+ (NPPublicBeacon *)beaconWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag Location:(TYLocalPoint *)location ShopGid:(NSString *)shopID
{
    NPPublicBeacon *beacon = [[NPPublicBeacon alloc] initWithUUID:uuid Major:major Minor:minor Tag:tag Location:location];
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

