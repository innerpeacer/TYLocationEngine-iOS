#import "NPMovingAverageTD.h"
#import "NPSample.h"

@implementation NPMovingAverageTD
@synthesize average = average;

- (id)initWithWindow:(double)w
{
    self = [super init];
    if (self) {
        window = w;
        queue = [[NSMutableArray alloc] init];

        lastTimeStamp = 0;
        timeIntervalContained = 0;
        average = 0.0;
        sum = 0;

    }
    return self;
}

- (void)push:(NSNumber *)value At:(CFTimeInterval)timeStamp
{
    if (lastTimeStamp == 0) {
        lastTimeStamp = timeStamp;
        return;
    }

    while (timeIntervalContained > window) {
        NPSample *tmp = [queue objectAtIndex:0];
        sum -= tmp.value * tmp.delta;
        timeIntervalContained -= tmp.delta;
        [queue removeObjectAtIndex:0];
    }

    double newDelta = timeStamp - lastTimeStamp;
    NPSample *newSample = [NPSample newSample:value.doubleValue delta:newDelta];
    [queue addObject: newSample];

    sum += value.doubleValue * newDelta;
    timeIntervalContained += newDelta;
    average = sum / timeIntervalContained;
    lastTimeStamp = timeStamp;
}

- (void)reset
{
    [queue removeAllObjects];
    lastTimeStamp = 0;
    sum = 0;
    timeIntervalContained = 0;
    average = 0;
}


- (double)getRate
{
    if (timeIntervalContained == 0) {
        return 0;
    }
    return queue.count / timeIntervalContained;
}
@end



