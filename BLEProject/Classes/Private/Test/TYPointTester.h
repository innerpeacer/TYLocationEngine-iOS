#import <Foundation/Foundation.h>

@interface TYPointTester : NSObject



@property (nonatomic, strong) TYLocalPoint *testPoint;
@property (readonly) int testID;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSString *startDateString;


- (id)initWithTestPoint:(TYLocalPoint *)tp Date:(NSDate *)date TestID:(int)testID;
- (BOOL)isEnough;
- (void)addTestPoint:(TYLocalPoint *)tp Time:(NSTimeInterval)timeStamp;
- (double)getAverageAccuracy;
- (void)writeToFile;

@end
