//
//  PDRSimulatorVC.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/11.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "PDRSimulatorVC.h"
#import "TYRawDataManager.h"

@interface PDRSimulatorVC ()
{
    TYRawDataCollection *collection;
}
@end

@implementation PDRSimulatorVC

- (void)viewDidLoad {
    [super viewDidLoad];

    collection = [TYRawDataManager getData:self.dataID];
    BRTLog(@"Data: %@", collection);
}

@end
