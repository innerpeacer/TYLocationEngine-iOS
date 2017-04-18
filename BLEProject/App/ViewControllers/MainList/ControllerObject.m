//
//  ControllerObject.m
//  BLEProject
//
//  Created by innerpeacer on 2017/4/18.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "ControllerObject.h"

@implementation ControllerObject

@end

@implementation ControllerCollections

+ (NSArray *)bleToolControllers
{
    NSArray *viewControllers = @[
                                 @[@"当前地图", @"mapViewController"],
                                 @[@"添加BeaconRegion", @"AddBeaconRegionVC"],
                                 @[@"添加Beacon", @"addPrimitiveController"],
                                 @[@"配置Beacon", @"ConfigureBeaconsVC"],
                                 @[@"验证Beacon数据", @"CheckBeaconDatabaseVC"],
                                 @[@"上传定位数据", @"UploadLocatingDataVC"],
                                 @[@"下载定位数据", @"DownloadLocatingDataVC"],
                                 @[@"获取定位数据", @"FetchLocatingDataVC"],
                                 @[@"配置点位图", @"ConfigurePointPositionVC"],
                                 ];
    return [ControllerCollections getControllerArray:viewControllers];
}

+ (NSArray *)bleAlgorithmControllers
{
    NSArray *viewControllers = @[
                                 @[@"Cpp Engine 测试",@"cppEngineController"],
                                 ];
    return [ControllerCollections getControllerArray:viewControllers];
}

+ (NSArray *)mapControllers
{
    NSArray *viewControllers = @[
                                 @[@"ArcGIS地图", @"cityListController"],
                                 ];
    return [ControllerCollections getControllerArray:viewControllers];
}


+ (NSArray *)getControllerArray:(NSArray *)array
{
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; ++i) {
        NSArray *obj = array[i];
        ControllerObject *controller = [[ControllerObject alloc] init];
        controller.name = [NSString stringWithFormat:@"%d. %@", i, obj[0]];
        controller.storyboardID = obj[1];
        [controllers addObject:controller];
    }
    return controllers;
}

@end
