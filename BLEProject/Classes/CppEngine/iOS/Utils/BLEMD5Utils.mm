//
//  BLEMD5Utils.m
//  BLEProject
//
//  Created by innerpeacer on 15/9/24.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "BLEMD5Utils.h"
#include "BLEMD5.hpp"

using namespace Innerpeacer::BLELocationEngine;

@implementation BLEMD5Utils

+ (NSString *)md5:(NSString *)str
{
    BLEMD5 md5([str UTF8String]);
    return [NSString stringWithUTF8String:md5.toString().c_str()];
}

+ (NSString *)md5ForFile:(NSString *)path
{
    std::ifstream in([path UTF8String], std::ios::in|std::ios::binary);
    BLEMD5 md5(in);
    
    return [NSString stringWithUTF8String:md5.toString().c_str()];
}

+ (NSString *)md5ForDirectory:(NSString *)dir
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator;
    enumerator = [fileManager enumeratorAtPath:dir];
    
    NSString *name;
    BLEMD5 fileMD5;
    
    while (name = [enumerator nextObject]) {
        NSString *sourcePath = [dir stringByAppendingPathComponent:name];
        std::ifstream in([sourcePath UTF8String], std::ios::in|std::ios::binary);
        fileMD5.update(in);
    }
    
    return [NSString stringWithUTF8String:fileMD5.toString().c_str()];
}

@end
