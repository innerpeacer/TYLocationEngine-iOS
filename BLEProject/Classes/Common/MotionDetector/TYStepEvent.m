#import "TYStepEvent.h"

@implementation TYStepEvent
@synthesize probability, duration;

+ (TYStepEvent *)newStepWithProbability:(double)prob Duration:(double)dur
{
    return [[TYStepEvent alloc] initWithProbability:prob Duration:dur];
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

