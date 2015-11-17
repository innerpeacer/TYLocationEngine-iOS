//
//  BLEEncryption.h
//  BLEProject
//
//  Created by innerpeacer on 15/11/15.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEEncryption : NSObject

+ (NSString *)decryptString:(NSString *)string;
+ (NSString *)decryptString:(NSString *)string withKey:(NSString *)key;

+ (NSString *)encryptString:(NSString *)string;
+ (NSString *)encryptString:(NSString *)string withKey:(NSString *)key;

@end
