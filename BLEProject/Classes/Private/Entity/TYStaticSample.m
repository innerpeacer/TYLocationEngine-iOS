#import "TYStaticSample.h"

@interface TYStaticSample()

@property (nonatomic, strong) NSMutableArray *sampleArray;
@end

@implementation TYStaticSample

- (id)initWithSampleID:(int)sID
{
    self = [super init];
    if (self) {
        _sampleID = sID;
        _sampleArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addSampleData:(TYSampeData *)data
{
    [_sampleArray addObject:data];
}

- (NSArray *)getSampleArray
{
    return _sampleArray;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"(%f, %f) %d samples", _location.x, _location.y, (int)_sampleArray.count];
}

@end