#import <Foundation/Foundation.h>

typedef enum type {
   UNKNOWN, PUBLIC, TRIGGER, ACTIVITY
} TYPE;

/**
 *  Beacon
 */
@interface NPBeacon : NSObject

/**
 *  Beacon UUID
 */
@property (readonly, strong) NSString *UUID;

/**
 *  Beacon Major
 */
@property (readonly, strong) NSNumber *major;

/**
 *  Beacon Minor
 */
@property (readonly, strong) NSNumber *minor;

/**
 *  Beacon Tag
 */
@property (readonly, strong) NSString *tag;


/**
 *  Beacon Type
 */
@property (assign) TYPE type;

/**
 *  Class method for creating a NPBeacon
 *
 *  @param uuid  Beacon UUID
 *  @param major Beacon Major
 *  @param minor Beacon Minor
 *  @param tag   Beacon Tag
 *
 *  @return NPBeacon
 */
+ (NPBeacon *)beaconWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag;

/**
 *  Class method for creating a CABeacon
 *
 *  @param uuid  Beacon UUID
 *  @param uuid  Beacon UUID
 *  @param major Beacon Major
 *  @param minor Beacon Minor
 *  @param tag   Beacon Tag
 *
 *  @return NPBeacon
 */
+ (NPBeacon *)beaconWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag Type:(TYPE) type;


- (id)initWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag Type:(TYPE)type;

@end