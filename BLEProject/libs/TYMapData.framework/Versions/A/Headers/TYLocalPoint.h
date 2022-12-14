#import <Foundation/Foundation.h>

#define LARGE_DISTANCE 100000000

/**
 *  位置点类
 */
@interface TYLocalPoint : NSObject

/**
 *  x坐标
 */
@property (readonly) double x;

/**
 *  y坐标
 */
@property (readonly) double y;

/**
 *  位置点所在楼层
 */
@property (assign) int floor;

+ (TYLocalPoint *)pointWithX:(double)x Y:(double)y;
+ (TYLocalPoint *)pointWithX:(double)x Y:(double)y Floor:(int)f;

/**
 *  计算当前点P到特定点P'的距离
 *
 *  @param p 特定点P'
 *
 *  @return 两点间距离
 */
- (double)distanceWith:(TYLocalPoint *)p;

/**
 *  计算两点P1、P2间的距离
 *
 *  @param p1 点P1
 *  @param p2 点P2
 *
 *  @return 两点间距离
 */
+ (double)distanceBetween:(TYLocalPoint *)p1 and:(TYLocalPoint *)p2;

@end
