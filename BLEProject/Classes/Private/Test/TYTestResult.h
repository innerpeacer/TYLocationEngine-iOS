#import <Foundation/Foundation.h>

@interface TYTestResult : NSObject

@property (readonly) int testID;
@property (nonatomic, strong) TYLocalPoint *location;
@property (nonatomic, strong) NSString *date;
@property (readonly) double accuracy;

+ (TYTestResult *)testResultWithID:(int)ID Accuracy:(double)acc;

@end
