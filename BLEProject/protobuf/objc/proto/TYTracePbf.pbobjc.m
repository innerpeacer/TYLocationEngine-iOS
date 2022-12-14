//// Generated by the protocol buffer compiler.  DO NOT EDIT!
//// source: t_y_trace_pbf.proto
//
//// This CPP symbol can be defined to use imports that match up to the framework
//// imports needed when using CocoaPods.
//#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
// #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
//#endif
//
//#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
// #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
//#else
// #import "GPBProtocolBuffers_RuntimeSupport.h"
//#endif
//
// #import "TYTracePbf.pbobjc.h"
//// @@protoc_insertion_point(imports)
//
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//
//#pragma mark - TYTracePbfRoot
//
//@implementation TYTracePbfRoot
//
//// No extensions in the file and no imports, so no need to generate
//// +extensionRegistry.
//
//@end
//
//#pragma mark - TYTracePbfRoot_FileDescriptor
//
//static GPBFileDescriptor *TYTracePbfRoot_FileDescriptor(void) {
//  // This is called by +initialize so there is no need to worry
//  // about thread safety of the singleton.
//  static GPBFileDescriptor *descriptor = NULL;
//  if (!descriptor) {
//    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
//    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"innerpeacer.trace"
//                                                     syntax:GPBFileSyntaxProto2];
//  }
//  return descriptor;
//}
//
//#pragma mark - TYTracePointPbf
//
//@implementation TYTracePointPbf
//
//@dynamic hasIndex, index;
//@dynamic hasX, x;
//@dynamic hasY, y;
//@dynamic hasFloor, floor;
//@dynamic hasTimestamp, timestamp;
//
//typedef struct TYTracePointPbf__storage_ {
//  uint32_t _has_storage_[1];
//  uint32_t index;
//  uint32_t floor;
//  double x;
//  double y;
//  double timestamp;
//} TYTracePointPbf__storage_;
//
//// This method is threadsafe because it is initially called
//// in +initialize for each subclass.
//+ (GPBDescriptor *)descriptor {
//  static GPBDescriptor *descriptor = nil;
//  if (!descriptor) {
//    static GPBMessageFieldDescription fields[] = {
//      {
//        .name = "index",
//        .dataTypeSpecific.className = NULL,
//        .number = TYTracePointPbf_FieldNumber_Index,
//        .hasIndex = 0,
//        .offset = (uint32_t)offsetof(TYTracePointPbf__storage_, index),
//        .flags = GPBFieldRequired,
//        .dataType = GPBDataTypeUInt32,
//      },
//      {
//        .name = "x",
//        .dataTypeSpecific.className = NULL,
//        .number = TYTracePointPbf_FieldNumber_X,
//        .hasIndex = 1,
//        .offset = (uint32_t)offsetof(TYTracePointPbf__storage_, x),
//        .flags = GPBFieldRequired,
//        .dataType = GPBDataTypeDouble,
//      },
//      {
//        .name = "y",
//        .dataTypeSpecific.className = NULL,
//        .number = TYTracePointPbf_FieldNumber_Y,
//        .hasIndex = 2,
//        .offset = (uint32_t)offsetof(TYTracePointPbf__storage_, y),
//        .flags = GPBFieldRequired,
//        .dataType = GPBDataTypeDouble,
//      },
//      {
//        .name = "floor",
//        .dataTypeSpecific.className = NULL,
//        .number = TYTracePointPbf_FieldNumber_Floor,
//        .hasIndex = 3,
//        .offset = (uint32_t)offsetof(TYTracePointPbf__storage_, floor),
//        .flags = GPBFieldRequired,
//        .dataType = GPBDataTypeUInt32,
//      },
//      {
//        .name = "timestamp",
//        .dataTypeSpecific.className = NULL,
//        .number = TYTracePointPbf_FieldNumber_Timestamp,
//        .hasIndex = 4,
//        .offset = (uint32_t)offsetof(TYTracePointPbf__storage_, timestamp),
//        .flags = GPBFieldRequired,
//        .dataType = GPBDataTypeDouble,
//      },
//    };
//    GPBDescriptor *localDescriptor =
//        [GPBDescriptor allocDescriptorForClass:[TYTracePointPbf class]
//                                     rootClass:[TYTracePbfRoot class]
//                                          file:TYTracePbfRoot_FileDescriptor()
//                                        fields:fields
//                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
//                                   storageSize:sizeof(TYTracePointPbf__storage_)
//                                         flags:GPBDescriptorInitializationFlag_None];
//    NSAssert(descriptor == nil, @"Startup recursed!");
//    descriptor = localDescriptor;
//  }
//  return descriptor;
//}
//
//@end
//
//#pragma mark - TYTracePbf
//
//@implementation TYTracePbf
//
//@dynamic hasTraceId, traceId;
//@dynamic hasTimestamp, timestamp;
//@dynamic pointsArray, pointsArray_Count;
//
//typedef struct TYTracePbf__storage_ {
//  uint32_t _has_storage_[1];
//  NSString *traceId;
//  NSMutableArray *pointsArray;
//  double timestamp;
//} TYTracePbf__storage_;
//
//// This method is threadsafe because it is initially called
//// in +initialize for each subclass.
//+ (GPBDescriptor *)descriptor {
//  static GPBDescriptor *descriptor = nil;
//  if (!descriptor) {
//    static GPBMessageFieldDescription fields[] = {
//      {
//        .name = "traceId",
//        .dataTypeSpecific.className = NULL,
//        .number = TYTracePbf_FieldNumber_TraceId,
//        .hasIndex = 0,
//        .offset = (uint32_t)offsetof(TYTracePbf__storage_, traceId),
//        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
//        .dataType = GPBDataTypeString,
//      },
//      {
//        .name = "timestamp",
//        .dataTypeSpecific.className = NULL,
//        .number = TYTracePbf_FieldNumber_Timestamp,
//        .hasIndex = 1,
//        .offset = (uint32_t)offsetof(TYTracePbf__storage_, timestamp),
//        .flags = GPBFieldRequired,
//        .dataType = GPBDataTypeDouble,
//      },
//      {
//        .name = "pointsArray",
//        .dataTypeSpecific.className = GPBStringifySymbol(TYTracePointPbf),
//        .number = TYTracePbf_FieldNumber_PointsArray,
//        .hasIndex = GPBNoHasBit,
//        .offset = (uint32_t)offsetof(TYTracePbf__storage_, pointsArray),
//        .flags = GPBFieldRepeated,
//        .dataType = GPBDataTypeMessage,
//      },
//    };
//    GPBDescriptor *localDescriptor =
//        [GPBDescriptor allocDescriptorForClass:[TYTracePbf class]
//                                     rootClass:[TYTracePbfRoot class]
//                                          file:TYTracePbfRoot_FileDescriptor()
//                                        fields:fields
//                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
//                                   storageSize:sizeof(TYTracePbf__storage_)
//                                         flags:GPBDescriptorInitializationFlag_None];
//#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
//    static const char *extraTextFormatInfo =
//        "\001\001\006A\000";
//    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
//#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
//    NSAssert(descriptor == nil, @"Startup recursed!");
//    descriptor = localDescriptor;
//  }
//  return descriptor;
//}
//
//@end
//
//
//#pragma clang diagnostic pop
//
//// @@protoc_insertion_point(global_scope)
