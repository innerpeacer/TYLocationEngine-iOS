#import "DoubleRounder.h"

@implementation DoubleRounder

+ (double)round2:(double)d
{
    return round(d * 100.0) / 100.0;
}

+ (double)round3:(double)d
{
    return round(d * 1000.0) / 1000.0;
}

@end
