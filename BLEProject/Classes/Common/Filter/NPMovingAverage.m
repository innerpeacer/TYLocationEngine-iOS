#import "NPMovingAverage.h"

@implementation NPMovingAverage
@synthesize average=average;

- (id)initWithWindow:(int)w
{
    self = [super init];
    if (self) {
        window = w;
        average = 0.0;
        queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)push:(NSNumber *)value;
{
    int size = (int) queue.count;
    
    assert(size <= window);
    
    double sum = average * size;
    
    if (size == window) {
        double tmp =[[queue objectAtIndex:0] doubleValue];
        [queue removeObjectAtIndex:0];
        
        sum -= tmp;
        size--;
    }
    
    average = (sum + value.doubleValue) / (size + 1);
    
    [queue addObject:value];
}

- (void)clear
{
    [queue removeAllObjects];
    average = 0.0;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Average: %f", average];
}

@end