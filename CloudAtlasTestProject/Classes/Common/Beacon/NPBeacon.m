#import "NPBeacon.h"

@implementation NPBeacon

- (id)initWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag Type:(TYPE)type
{
    self = [super init];
    if (self) {
        _UUID = uuid;
        _major = major;
        _minor = minor;
        _tag = tag;
        _type = type;
    }
    return self;
}

+ (NPBeacon *)beaconWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag
{
    return [[NPBeacon alloc] initWithUUID:uuid Major:major Minor:minor Tag:tag Type:UNKNOWN];
}

+ (NPBeacon *)beaconWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag Type:(TYPE) type
{
    return [[NPBeacon alloc] initWithUUID:uuid Major:major Minor:minor Tag:tag Type:type];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Major: %@, Minor: %@ Tag: %@, Type:%d", _major, _minor, _tag, _type];
}

@end