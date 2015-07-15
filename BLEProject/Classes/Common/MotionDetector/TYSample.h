#import <Foundation/Foundation.h>

@interface TYSample : NSObject
{
    double delta;
    double value;
}
@property (readonly) double delta;
@property (readonly) double value;

+ (TYSample *)newSample:(double)v delta:(double)d;

@end
