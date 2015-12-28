//
//  CheckBeaconDatabaseVC.m
//  BLEProject
//
//  Created by innerpeacer on 15/9/25.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "CheckBeaconDatabaseVC.h"
#import <TYMapSDK/TYMapSDK.h>
#import "TYBeaconFMDBAdapter.h"
#import "TYBeaconDBCodeChecker.h"

@interface CheckBeaconDatabaseVC()
{
    
}

@end

@implementation CheckBeaconDatabaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"验证Beacon数据";
    
    [self addToLog:@"开始验证"];
    [self checkBeaconDatabase];
    [self addToLog:@"结束验证"];
}

- (void)checkBeaconDatabase
{
    NSArray *allCities = [TYCityManager parseAllCities];
    for (TYCity *city in allCities) {
        NSArray *allBuildings = [TYBuildingManager parseAllBuildings:city];
        for (TYBuilding *building in allBuildings) {
            
            TYBeaconFMDBAdapter *db = [[TYBeaconFMDBAdapter alloc] initWithBuilding:building];
            [db open];
            
            NSArray *array = [db getAllLocationingBeacons];
            
            NSString *code;
            if (array && array.count > 0) {
                code = [TYBeaconDBCodeChecker checkBeacons:array];
                if ([db getCheckCode]) {
                    [db updateCheckCode:code];
                } else {
                    [db insertCheckCode:code];
                }
            }
            
            [db close];
            [self addToLog:[NSString stringWithFormat:@"Building %@: %@", building.buildingID, code]];

        }
    }
}

@end
