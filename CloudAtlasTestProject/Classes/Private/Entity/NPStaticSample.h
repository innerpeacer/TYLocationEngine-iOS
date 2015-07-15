#import <Foundation/Foundation.h>
#import "NPStaticSample.h"
#import "NPSampeData.h"

@interface NPStaticSample : NSObject

@property (nonatomic, readonly) int sampleID;
@property (nonatomic, strong) TYLocalPoint *location;


- (id)initWithSampleID:(int)sID;

- (void)addSampleData:(NPSampeData *)data;
- (NSArray *)getSampleArray;

@end