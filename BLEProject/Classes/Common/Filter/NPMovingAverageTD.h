#import <Foundation/Foundation.h>

/**
 *  时分滑动平均滤波器
 */
@interface NPMovingAverageTD : NSObject
{
    double window;

    CFTimeInterval lastTimeStamp;
    double timeIntervalContained;

    double average;
    double sum;

    NSMutableArray *queue;
}

/**
 *  平均值
 */
@property (readonly) double average;

/**
 *  实例化滤波器类
 *
 *  @param w 窗口时间宽度
 *
 *  @return 滤波器实例
 */
- (id)initWithWindow:(double)window;

/**
 *  Push滤波值
 *
 *  @param value     滤波值
 *  @param timeStamp 滤波值时间戳
 */
- (void)push:(NSNumber *)value At:(CFTimeInterval)timeStamp;

/**
 *  重置滤波器
 */
- (void)reset;

/**
 *  返回数据率
 *
 *  @return 单位时间数据量
 */
- (double)getRate;

@end
