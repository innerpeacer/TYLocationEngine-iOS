#import <Foundation/Foundation.h>

@interface NPStepEvent : NSObject
{
    double probability;
    double duration;
}

@property (readonly) double probability;
@property (readonly) double duration;

+ (NPStepEvent *)newStepWithProbability:(double)prob Duration:(double)dur;

@end
