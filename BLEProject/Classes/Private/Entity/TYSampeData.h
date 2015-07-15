#import <Foundation/Foundation.h>

@interface TYSampeData : NSObject

@property (nonatomic, assign) int major;
@property (nonatomic, assign) int minor;

@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, assign) double accuracy;
@property (nonatomic, assign) int rssi;

@end
