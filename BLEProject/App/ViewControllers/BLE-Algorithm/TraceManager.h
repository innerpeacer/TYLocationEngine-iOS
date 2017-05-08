//
//  TraceManager.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/7.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTrace.h"

@interface TraceManager : NSObject

+ (TYTrace *)currentTrace;
+ (void)setCurrentTrace:(TYTrace *)trace;

+ (TYTrace *)createNewTrace;
+ (TYTrace *)createPureTrace;

+ (void)saveTrace:(TYTrace *)trace;
+ (void)deleteTrace:(NSString *)traceID;
+ (void)deleteAllTraces;
+ (TYTrace *)getTrace:(NSString *)traceID;
+ (NSArray *)getTraces;

@end
