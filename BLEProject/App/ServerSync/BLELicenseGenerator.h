//
//  BLELicenseGenerator.h
//  BLEProject
//
//  Created by innerpeacer on 15/11/15.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLELicenseGenerator : NSObject

+ (NSString *)generateLicenseForUserID:(NSString *)userID Building:(NSString *)building ExpiredDate:(NSString *)expiredDate;

@end
