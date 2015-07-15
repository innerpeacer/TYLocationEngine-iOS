#import "NPPointTester.h"


#define TEST_NUMBER 20

@interface NPPointTester()
{
    NSMutableArray *resultPointArray;
    NSMutableArray *timestampsArray;
}

@end

@implementation NPPointTester

static NSDateFormatter *dateFormatter;

+ (NSDateFormatter *)defaultFormatter
{
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"MM-dd-HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    }
    return dateFormatter;
}

- (id)initWithTestPoint:(TYLocalPoint *)tp Date:(NSDate *)date TestID:(int)testID
{
    self = [super init];
    if (self) {
        _testPoint = tp;
        _testID = testID;
        _startDate = date;
        NSDateFormatter *formatter = [NPPointTester defaultFormatter];
        _startDateString = [formatter stringFromDate:_startDate];
        
        resultPointArray = [[NSMutableArray alloc] init];
        timestampsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)isEnough
{
    return resultPointArray.count >= TEST_NUMBER;
}

- (void)addTestPoint:(TYLocalPoint *)tp Time:(NSTimeInterval)timeStamp
{
    [resultPointArray addObject:tp];
    [timestampsArray addObject:@(timeStamp)];
}

- (double)getAverageAccuracy
{
    double sum = 0.0;
    for (TYLocalPoint *lp in resultPointArray) {
        double dis = [TYLocalPoint distanceBetween:lp and:_testPoint];
        sum += dis;
    }
    
    int size = (int) resultPointArray.count;
    size = (size == 0) ? 1 : size;
    
    return (sum / size);
}

- (void)writeToFile
{
    if (![self isEnough]) {
        NSLog(@"Error: Not Enough Test Point");
    }
    assert([self isEnough]);
    
    NSString *fileName = [NSString stringWithFormat:@"TestPoint-%d.txt", _testID];
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *path = [[dir stringByAppendingPathComponent:@"PointTest"] stringByAppendingPathComponent:fileName];
    
    NSMutableString *resultString = [NSMutableString string];
   
    [resultString appendString:@"Test Point\t"];
    [resultString appendFormat:@"%.2f\t", _testPoint.x];
    [resultString appendFormat:@"%.2f\t", _testPoint.y];
    [resultString appendFormat:@"%@\t", _startDateString];
    [resultString appendFormat:@"%d\n", _testID];
    
    for (int i = 0; i < resultPointArray.count; ++i) {
        TYLocalPoint *result = [resultPointArray objectAtIndex:i];
        NSTimeInterval time = [[timestampsArray objectAtIndex:i] doubleValue];
        
        double distance = [TYLocalPoint distanceBetween:result and:_testPoint];
        NSString *isValid = (distance <= 2.0) ? @"Succeed" : @"Failed";
        
        [resultString appendFormat:@"Point%d\t", i+1];
        [resultString appendFormat:@"%.2f\t", result.x];
        [resultString appendFormat:@"%.2f\t", result.y];
        [resultString appendFormat:@"%.2f\t", distance];
        [resultString appendFormat:@"%@\t", isValid];
        [resultString appendFormat:@"%.2f", time];

        if (i != resultPointArray.count - 1) {
            [resultString appendFormat:@"\n"];
        }
    }

    
    NSLog(@"%@", resultString);
    NSLog(@"Path: %@", path);
    NSData *data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:path atomically:YES];
    
    NSLog(@"writeToFile");
}


@end
