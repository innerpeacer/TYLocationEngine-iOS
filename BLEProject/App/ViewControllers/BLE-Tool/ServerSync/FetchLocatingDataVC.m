//
//  FetchLocatingDataVC.m
//  BLEProject
//
//  Created by innerpeacer on 16/1/4.
//  Copyright © 2016年 innerpeacer. All rights reserved.
//

#import "FetchLocatingDataVC.h"

#import "TYBLEDataManager.h"

#import "TYUserManager.h"
#import "TYUserDefaults.h"

@interface FetchLocatingDataVC() <TYBLEDataManagerDelegate>
{
    TYBLEDataManager *dataManager;
    TYBuilding *currentBuilding;
}

- (IBAction)fetchData:(id)sender;

@end

@implementation FetchLocatingDataVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentBuilding = [TYUserDefaults getDefaultBuilding];
    
    TYMapCredential *user = [TYUserManager createTrialUser:currentBuilding.buildingID];
    dataManager = [[TYBLEDataManager alloc] initWithUserID:user.userID Building:currentBuilding License:user.license];
    dataManager.delegate = self;
}

- (IBAction)fetchData:(id)sender
{
    NSLog(@"fetchData");
    [dataManager fetchLocatingData];
}

- (void)TYBLEDataManagerDidFailedFetchingData:(TYBLEDataManager *)manager WithError:(NSError *)error
{
    
}

- (void)TYBLEDataManagerDidFinishFetchingData:(TYBLEDataManager *)manager
{
    [self addToLog:@"Finish Fetch Data"];
}

@end
