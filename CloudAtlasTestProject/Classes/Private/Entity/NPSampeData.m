#import "NPSampeData.h"

@implementation NPSampeData

- (NSString *)description
{
    return [NSString stringWithFormat:@"Minor: %d, Rssi: %d", _major, _rssi];
}

@end
