//
//  TYBLEEnvironment.m
//  BLEProject
//
//  Created by innerpeacer on 16/6/17.
//  Copyright © 2016年 innerpeacer. All rights reserved.
//

#import "TYBLEEnvironment.h"
#import "IPXLibraryVersion.hpp"

#define SDK_VERSION @"1.0.2"

@implementation TYBLEEnvironment

static NSString *bleFileRootDirectory;

+ (NSString *)getRootDirectoryForFiles
{
    return bleFileRootDirectory;
}

+ (void)setRootDirectoryForFiles:(NSString *)dir
{
    bleFileRootDirectory = [NSString stringWithString:dir];
}

+ (NSString *)getSDKVersion
{
    return SDK_VERSION;
}

+ (NSString *)getLibraryVersion
{
    return [NSString stringWithUTF8String:getBLELibraryVersion().c_str()];
}

@end
