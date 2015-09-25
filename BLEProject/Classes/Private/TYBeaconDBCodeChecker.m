//
//  TYBeaconDBCodeChecker.m
//  BLEProject
//
//  Created by innerpeacer on 15/9/24.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "TYBeaconDBCodeChecker.h"
#import "BLEMD5Utils.h"
#import "TYPublicBeacon.h"

@implementation TYBeaconDBCodeChecker

+ (NSString *)checkBeacons:(NSArray *)array
{
    if (array == nil || array.count == 0) {
        return nil;
    }
    
    long sum = 0;
    int count = (int)array.count;
    
    for (TYPublicBeacon *pb in array) {
        sum += pb.major.intValue;
        sum += pb.minor.intValue;
    }
    sum = sum * count;
    
    NSString *beaconString = [NSString stringWithFormat:@"%ld", sum];
//    NSLog(@"%@", beaconString);
    
    NSString *code = [BLEMD5Utils md5:beaconString];
//    NSLog(@"Code: %@", code);
    
    return code;
}
@end
