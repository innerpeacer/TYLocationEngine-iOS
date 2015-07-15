#import "TYDistributionResult.h"

@implementation TYDistributionResult

+ (TYDistributionResult *)resultWithLocation:(TYLocalPoint *)location Accuracy:(double)acc
{
    return [[TYDistributionResult alloc] initWithLocation:location Accuracy:acc];
}

- (id)initWithLocation:(TYLocalPoint *)location Accuracy:(double)acc
{
    self = [super init];
    if (self) {
        _location = location;
        _accuracy = acc;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %f", _location, _accuracy];
}

@end
