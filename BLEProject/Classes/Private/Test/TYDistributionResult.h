#import <Foundation/Foundation.h>

@interface TYDistributionResult : NSObject

+ (TYDistributionResult *)resultWithLocation:(TYLocalPoint *)location Accuracy:(double)acc;

@property (nonatomic, strong) TYLocalPoint *location;
@property (nonatomic, readonly) double accuracy;

@end
