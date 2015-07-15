#import "TYSampeData.h"

@implementation TYSampeData

- (NSString *)description
{
    return [NSString stringWithFormat:@"Minor: %d, Rssi: %d", _major, _rssi];
}

@end
