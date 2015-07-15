#import <Foundation/Foundation.h>

@interface NPTestResult : NSObject

@property (readonly) int testID;
@property (nonatomic, strong) TYLocalPoint *location;
@property (nonatomic, strong) NSString *date;
@property (readonly) double accuracy;

+ (NPTestResult *)testResultWithID:(int)ID Accuracy:(double)acc;

@end
