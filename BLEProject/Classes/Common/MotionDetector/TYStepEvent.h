#import <Foundation/Foundation.h>

/**
 *  计步器事件
 */
@interface TYStepEvent : NSObject
{
    double probability;
    double duration;
}

/**
 *  计步器事件的概率
 */
@property (readonly) double probability;

/**
 *  计步器事件持续的时间
 */
@property (readonly) double duration;

/**
 *  实例化一个计步器事件
 *
 *  @param prob 计步器事件的概率
 *  @param dur  计步器事件持续的时间
 *
 *  @return 计步器事件
 */
+ (TYStepEvent *)newStepWithProbability:(double)prob Duration:(double)dur;

@end
