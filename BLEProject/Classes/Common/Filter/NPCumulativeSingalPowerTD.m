#import "NPCumulativeSingalPowerTD.h"

@implementation NPCumulativeSingalPowerTD
@synthesize power = power;

- (id)init
{
    self = [super init];
    if (self) {
        power = 0.0;
        lastTimeStamp = 0;

    }
    return self;
}

- (void)push:(NSNumber *)value At:(CFTimeInterval)timeStamp;
{
    if (lastTimeStamp == 0) {
        lastTimeStamp = timeStamp;
        return;
    }

    double delta = timeStamp - lastTimeStamp;
    power += value.doubleValue * value.doubleValue /delta;
    lastTimeStamp = timeStamp;
}

- (void)reset
{
    power = 0.0;
}

@end
