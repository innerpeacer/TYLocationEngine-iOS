#import <Foundation/Foundation.h>

@interface TYStepEvent : NSObject
{
    double probability;
    double duration;
}

@property (readonly) double probability;
@property (readonly) double duration;

+ (TYStepEvent *)newStepWithProbability:(double)prob Duration:(double)dur;

@end
