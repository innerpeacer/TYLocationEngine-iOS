#import "TYBeacon.h"
#import <TYMapData/TYMapData.h>

/**
 *  公共Beacon类，当前用于表示固定部署用于定位的beacon
 */
@interface TYPublicBeacon : TYBeacon

/**
 *  Beacon所部署的位置
 */
@property (nonatomic, strong) TYLocalPoint *location;

/**
 *  Beacon部署位置所属的商铺，可以为空
 */
@property (nonatomic, strong) NSString *shopGid;

+ (TYPublicBeacon *)beaconWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag Location:(TYLocalPoint *)location;
+ (TYPublicBeacon *)beaconWithUUID:(NSString *)uuid Major:(NSNumber *)major Minor:(NSNumber *)minor Tag:(NSString *)tag Location:(TYLocalPoint *)location ShopGid:(NSString *)shopID;
@end
