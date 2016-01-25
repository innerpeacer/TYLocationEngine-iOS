//
//  SelectBuildingVC.m
//  MapProject
//
//  Created by innerpeacer on 15/8/7.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "SelectBuildingVC.h"
#import "TYUserDefaults.h"

@interface SelectBuildingVC () <CityBuildingTableVCDelegate>

@end

@implementation SelectBuildingVC

- (void)viewDidLoad {
    
    self.cityArray = [TYCityManager parseAllCities];
    self.cityArray = [self.cityArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        TYCity *city1 = obj1;
        TYCity *city2 = obj2;
        return [city1.cityID caseInsensitiveCompare:city2.cityID];
    }];

    NSMutableArray *array = [NSMutableArray array];
    for (TYCity *city in self.cityArray) {
        NSArray *bArray = [TYBuildingManager parseAllBuildings:city];
        [array addObject:bArray];
    }
    self.buildingArray = [NSArray arrayWithArray:array];
    
    [super viewDidLoad];

    self.delegate = self;

    self.title = [NSString stringWithFormat:@"当前建筑: %@", [TYUserDefaults getDefaultBuilding].name];
}

- (void)didSelectBuilding:(TYBuilding *)building City:(TYCity *)city
{
    NSLog(@"SelectBuildingVC:didSelectBuilding: %@ - %@", building.name, city.name);
    [TYUserDefaults setDefaultBuilding:building.buildingID];
    [TYUserDefaults setDefaultCity:city.cityID];
    
    self.title = [NSString stringWithFormat:@"当前建筑: %@", [TYUserDefaults getDefaultBuilding].name];
}

@end
