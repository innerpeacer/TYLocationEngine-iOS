#import <Foundation/Foundation.h>

/**
 *  辅助几何计算类
 */
@interface TYGeometryCalculator : NSObject

/**
 *  对特定点P以特定中心C和特定距离L进行限幅：
 *      当此点P与中心C的距离小于特定距离L时，点位置P不变
 *      当此点P与中心C的距离大于特定距离L时，限制在距中心C半径为L的圆上
 *
 *  @param center      中心点位置C
 *  @param scaledPoint 待限幅点位置P
 *  @param length      限幅长度L
 *
 *  @return 限幅后的点位置P'
 */
+ (TYLocalPoint *)scalePointWithCenter:(TYLocalPoint *)center scaled:(TYLocalPoint *)scaledPoint ForLength:(double)length;

@end
