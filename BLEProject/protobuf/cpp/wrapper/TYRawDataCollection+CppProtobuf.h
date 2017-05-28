//
//  TYRawDataCollection+CppProtobuf.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/27.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYRawDataCollection.h"

#import "t_y_raw_data_collection_pbf.pb.h"
#include "IPXRawDataCollection.hpp"
#include "IPXPbfDBRecord.hpp"

using namespace innerpeacer::rawdata;

@interface TYRawStepEvent(CppProtobuf)
- (void)toCppPbf:(TYRawStepEventPbf *)pbf;
- (id)initWithPbf:(TYRawStepEventPbf *)pbf;
@end

@interface TYRawHeadingEvent(CppProtobuf)
- (void)toCppPbf:(TYRawHeadingEventPbf *)pbf;
- (id)initWithPbf:(TYRawHeadingEventPbf *)pbf;
@end

@interface TYRawBeaconSignal(CppProtobuf)
- (void)toCppPbf:(TYRawBeaconSignalPbf *)pbf;
- (id)initWithPbf:(TYRawBeaconSignalPbf *)pbf;
@end

@interface TYRawLocation(CppProtobuf)
- (void)toCppPbf:(TYRawLocationPbf *)pbf;
- (id)initWithPbf:(TYRawLocationPbf *)pbf;
@end

@interface TYRawSignalEvent(CppProtobuf)
- (void)toCppPbf:(TYRawSignalEventPbf *)pbf;
- (id)initWithPbf:(TYRawSignalEventPbf *)pbf;
@end

@interface TYRawDataCollection(CppProtobuf)
- (void)toCppPbf:(TYRawDataCollectionPbf *)pbf;
- (id)initWithPbf:(TYRawDataCollectionPbf *)pbf;
- (void)toPbfRecord:(IPXPbfDBRecord *)record;
+ (TYRawDataCollection *)fromCppPbfDBRecord:(IPXPbfDBRecord *)record;
@end


