#import "NPTestResult.h"

@implementation NPTestResult

+ (NPTestResult *)testResultWithID:(int)ID Accuracy:(double)acc
{
    return [[NPTestResult alloc] initWithID:ID Accuracy:acc];
}

- (id)initWithID:(int)ID Accuracy:(double)acc
{
    self = [super init];
    if (self) {
        _testID = ID;
        _accuracy = acc;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Test Result: %d - %f",_testID, _accuracy];
}

@end
