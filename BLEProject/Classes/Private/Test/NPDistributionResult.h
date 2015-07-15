#import <Foundation/Foundation.h>

@interface NPDistributionResult : NSObject

+ (NPDistributionResult *)resultWithLocation:(TYLocalPoint *)location Accuracy:(double)acc;

@property (nonatomic, strong) TYLocalPoint *location;
@property (nonatomic, readonly) double accuracy;

@end
