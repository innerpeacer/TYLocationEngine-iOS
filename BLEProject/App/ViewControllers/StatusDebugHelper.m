//
//  StatusDebugHelper.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/22.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "StatusDebugHelper.h"

@implementation StatusDebugHelper

+ (UIColor *)randomColorFromName:(NSString *)name
{
    if (name.length < 3) {
        return [UIColor blackColor];
    }
    
    NSString *str = [name uppercaseString];
    
    char redChar = [str characterAtIndex:0];
    char blueChar = [str characterAtIndex:1];
    char greenChar = [str characterAtIndex:2];
    
    float red = (redChar - 'A') * 1.0f / ('Z' - 'A');
    float blue = (blueChar - 'A') * 1.0f / ('Z' - 'A');
    float green = (greenChar - 'A') * 1.0f / ('Z' - 'A');
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end
