#import "NPStepEvent.h"

@implementation NPStepEvent
@synthesize probability, duration;

+ (NPStepEvent *)newStepWithProbability:(double)prob Duration:(double)dur
{
    return [[NPStepEvent alloc] initWithProbability:prob Duration:dur];
}

- (id)initWithProbability:(double)prob Duration:(double)dur
{
    self = [super init];
    if (self) {
        probability = prob;
        duration = dur;
    }
    return self;
}

@end

