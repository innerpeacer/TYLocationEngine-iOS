//
//  BLEEncryption.m
//  BLEProject
//
//  Created by innerpeacer on 15/11/15.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "BLEEncryption.h"
#import "IPXEncryption.hpp"
@implementation BLEEncryption


+ (NSString *)decryptString:(NSString *)string
{
    return [NSString stringWithCString:ble_encryptString([string UTF8String]).c_str() encoding:NSUTF8StringEncoding];
}

+ (NSString *)decryptString:(NSString *)string withKey:(NSString *)key
{
    return [NSString stringWithCString:ble_encryptString([string UTF8String], [key UTF8String]).c_str() encoding:NSUTF8StringEncoding];
}

+ (NSString *)encryptString:(NSString *)string
{
    return [BLEEncryption decryptString:string];
}

+ (NSString *)encryptString:(NSString *)string withKey:(NSString *)key
{
    return [BLEEncryption decryptString:string withKey:key];
}



@end
