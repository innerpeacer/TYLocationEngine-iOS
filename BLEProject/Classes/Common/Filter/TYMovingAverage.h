#import <Foundation/Foundation.h>

/*
 *  滑动平均滤波器
 */
@interface TYMovingAverage : NSObject {
    
    int window;
    double average;
    
    NSMutableArray *queue;
}

/*
 *  平均值
 */
@property (readonly) double average;

/*
 *  实例化滤波器类
 *
 *  @param w 窗口宽度，整型
 *
 *  @return 滤波器实例
 */
- (id)initWithWindow:(int)w;

/*
 *  Push滤波值
 *
 *  @param value 滤波值
 */
- (void)push:(NSNumber *)value;

/*
 *  清空滤波器
 */
- (void)clear;

@end
