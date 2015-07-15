//
//  CALocationAlgorithm.m
//  CloudAtlasTestProject
//
//  Created by innerpeacer on 15/1/28.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "NPLocationAlgorithm.h"

@interface NPLocationAlgorithm()
{
}

@end

@implementation NPLocationAlgorithm

- (id)initWithBeaconDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.beaconDictionary = [NSDictionary dictionaryWithDictionary:dict];
    }
    return self;
}

- (TYLocalPoint *)calculationLocation
{
    return nil;
}

@end
