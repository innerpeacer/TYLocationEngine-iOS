//
//  PbfDBRecord.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/5.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTrace.h"
#import "TYRawDataCollection.h"

typedef enum {
    PBF_TRACE_DATA = 1,
    
    PBF_RAW_DATA = 2,
    
    
    
    PBF_OTHER_DATA = 10
} PbfDataType;

@interface PbfDBRecord : NSObject
@property (nonatomic, strong) NSString *dataID;
@property (nonatomic, strong) NSData *pbfData;
@property (nonatomic, assign) PbfDataType dataType;
@property (nonatomic, strong) NSString *dataDescription;
@end

@interface TYTrace(PbfDBRecord)
- (PbfDBRecord *)toPbfDBRecord;
+ (TYTrace *)fromPbfDBRecord:(PbfDBRecord *)record;
@end

@interface TYRawDataCollection(PbfDBRecord)
- (PbfDBRecord *)toPbfDBRecord;
+ (TYRawDataCollection *)fromPbfDBRecord:(PbfDBRecord *)record;
@end
