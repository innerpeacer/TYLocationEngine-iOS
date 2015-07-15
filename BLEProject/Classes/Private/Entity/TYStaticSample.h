#import <Foundation/Foundation.h>
#import "TYStaticSample.h"
#import "TYSampeData.h"

@interface TYStaticSample : NSObject

@property (nonatomic, readonly) int sampleID;
@property (nonatomic, strong) TYLocalPoint *location;


- (id)initWithSampleID:(int)sID;

- (void)addSampleData:(TYSampeData *)data;
- (NSArray *)getSampleArray;

@end