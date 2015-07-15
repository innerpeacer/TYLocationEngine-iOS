#import <Foundation/Foundation.h>

@interface NPSample : NSObject
{
    double delta;
    double value;
}
@property (readonly) double delta;
@property (readonly) double value;

+ (NPSample *)newSample:(double)v delta:(double)d;

@end
