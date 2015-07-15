#import "TYSample.h"

@implementation TYSample
@synthesize delta, value;

+ (TYSample *)newSample:(double)v delta:(double)d
{
    return [[TYSample alloc] initWithValue:v andDelta:d];
}

- (id)initWithValue:(double)v andDelta:(double)d
{
    self = [super init];
    if (self) {
        value = v;
        delta = d;
    }
    return self;
}

@end
