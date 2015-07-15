#import <Foundation/Foundation.h>
#import <TYMapSDK/TYMapSDK.h>

@interface TYUserDefaults : NSObject

+ (void)setDefaultBuilding:(NSString *)buildingID;
+ (void)setDefaultCity:(NSString *)cityID;

+ (TYBuilding *)getDefaultBuilding;
+ (TYCity *)getDefaultCity;

@end
