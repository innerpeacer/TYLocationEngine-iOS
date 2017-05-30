//
//  TYTrace+CppProtobuf.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/30.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TYTrace.h"

#include "IPXTrace.hpp"
#include "IPXPbfDBRecord.hpp"
#include "t_y_trace_pbf.pb.h"

using namespace innerpeacer::trace;
using namespace innerpeacer::rawdata;

@interface TYTracePoint(CppProtobuf)
- (void)toCppPbf:(TYTracePointPbf *)pbf;
- (id)initWithPbf:(TYTracePointPbf *)pbf;
@end

@interface TYTrace(CppProtobuf)
- (void)toCppPbf:(TYTracePbf *)pbf;
- (id)initWithPbf:(TYTracePbf *)pbf;
- (void)toPbfRecord:(IPXPbfDBRecord *)record;
+ (TYTrace *)fromCppPbfDBRecord:(IPXPbfDBRecord *)record;
@end
