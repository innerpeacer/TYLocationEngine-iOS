//
//  BLELicenseGenerator.m
//  BLEProject
//
//  Created by innerpeacer on 15/11/15.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "BLELicenseGenerator.h"
#import "BLEEncryption.h"
#import "BLEMD5Utils.h"

@implementation BLELicenseGenerator

+ (NSString *)generateLicenseForUserID:(NSString *)userID Building:(NSString *)building ExpiredDate:(NSString *)expiredDate
{
    if (userID == nil || userID.length < 18) {
        NSLog(@"Invalid UserID.");
        return nil;
    }
    
    if (expiredDate == nil) {
        NSLog(@"Expired Date Cannot be nil.");
        return nil;
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        NSDate* date = [dateFormatter dateFromString:expiredDate];
        if (date == nil) {
            NSLog(@"Cannot parse Expired Date");
            return nil;
        }
    }
    
    NSString *key1 = [userID substringWithRange:NSMakeRange(2, 8)];
    NSString *key2 = [userID substringWithRange:NSMakeRange(10, 8)];
    NSString *encryptedBuildingID = [BLEEncryption encryptString:[building substringWithRange:NSMakeRange(0, 8)] withKey:key1];
    NSString *encryptedExpiredDate = [BLEEncryption encryptString:expiredDate withKey:key2];
    NSString *md5ForBuildingID = [BLEMD5Utils md5:encryptedBuildingID];
    NSString *originalMD5 = [NSString stringWithFormat:@"MAP%@%@", encryptedBuildingID, encryptedExpiredDate];
    
    NSString *md5String = [BLEMD5Utils md5:originalMD5];
    NSString *license = [NSString stringWithFormat:@"%@%@%@%@", [md5String substringWithRange:NSMakeRange(0, 8)], [BLEEncryption encryptString:encryptedBuildingID withKey:md5ForBuildingID], [BLEEncryption encryptString:encryptedExpiredDate withKey:md5ForBuildingID], [md5String substringWithRange:NSMakeRange(24, 8)]];
    
    //    NSLog(@"Key1: %@", key1);
    //    NSLog(@"Key2: %@", key2);
    //    NSLog(@"encryptedBuildingID: %@", encryptedBuildingID);
    //    NSLog(@"encryptedExpiredDate: %@", encryptedExpiredDate);
    //    NSLog(@"md5ForBuildingID: %@", md5ForBuildingID);
    //    NSLog(@"originalMD5: %@", originalMD5);
    //    NSLog(@"md5String: %@", md5String);
    //    NSLog(@"license: %@", license);
    return license;
}
@end
