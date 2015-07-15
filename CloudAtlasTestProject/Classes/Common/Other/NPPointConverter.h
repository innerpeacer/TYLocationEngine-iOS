#import <Foundation/Foundation.h>

@interface NPPointConverter : NSObject

+ (NSData *)dataFromX:(double)x Y:(double)y Z:(double)z;
+ (double *)xyzFromNSData:(NSData *)data;

@end
