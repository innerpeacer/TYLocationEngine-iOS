#import "NPSample.h"

@implementation NPSample
@synthesize delta, value;

+ (NPSample *)newSample:(double)v delta:(double)d
{
    return [[NPSample alloc] initWithValue:v andDelta:d];
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
