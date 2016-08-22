//
//  TYBLEEnvironment.m
//  BLEProject
//
//  Created by innerpeacer on 16/6/17.
//  Copyright © 2016年 innerpeacer. All rights reserved.
//

#import "TYBLEEnvironment.h"

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

@end
