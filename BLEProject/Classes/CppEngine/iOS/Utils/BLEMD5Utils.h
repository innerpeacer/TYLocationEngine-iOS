//
//  BLEMD5Utils.h
//  BLEProject
//
//  Created by innerpeacer on 15/9/24.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEMD5Utils : NSObject

+ (NSString *)md5:(NSString *)str;

+ (NSString *)md5ForFile:(NSString *)path;

+ (NSString *)md5ForDirectory:(NSString *)dir;

@end
