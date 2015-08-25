#import <Foundation/Foundation.h>

/*
 *  时分累积信号功率滤波器
 */
@interface TYCumulativeSingalPowerTD : NSObject
{
    double power;

    CFTimeInterval lastTimeStamp;
}

/*
 *  信号平均功率
 */
@property (readonly) double power;

/*
 *  Push滤波值
 *
 *  @param value     滤波值
 *  @param timeStamp 滤波值时间戳
 */
- (void)push:(NSNumber *)value At:(CFTimeInterval)timeStamp;

/*
 *  重置滤波器
 */
- (void)reset;
@end
