//
//  AddBeaconRegionVC.m
//  BLEProject
//
//  Created by innerpeacer on 15/12/28.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "AddBeaconRegionVC.h"
#import "TYUserDefaults.h"
#import <TYMapSDK/TYMapSDK.h>

#import "TYBeaconRegion.h"
#import "TYBeaconRegionDBAdapter.h"
#import "TYRegionManager.h"

@interface AddBeaconRegionVC()
{
    TYBuilding *currentBuilding;
}


@property (weak, nonatomic) IBOutlet UITextField *uuilTextField;
@property (weak, nonatomic) IBOutlet UITextField *majorTextField;
- (IBAction)addBeaconRegion:(id)sender;

@end

@implementation AddBeaconRegionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentBuilding = [TYUserDefaults getDefaultBuilding];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Region List" style:UIBarButtonItemStylePlain target:self action:@selector(showRegionList:)];

}

- (IBAction)addBeaconRegion:(id)sender {
    NSLog(@"UUID: %@, %d", self.uuilTextField.text, (int)self.uuilTextField.text.length);
    NSLog(@"Major: %@, %d", self.majorTextField.text, (int)self.uuilTextField.text.length);
    
    NSString *uuidString = self.uuilTextField.text;
    if (uuidString == nil || uuidString.length == 0) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Error!" message:@"UUID Cannot be Null" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }


//    uuidString = @"FDA50693-A4E2-4FB1-AFCF-C6EB07647825";
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    if (uuid == nil) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Invalid UUID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSLog(@"UUID: %@", uuid);
    NSLog(@"UUIDString: %@", uuidString);
    
    
    NSNumber *major = nil;
    NSString *majorString = self.majorTextField.text;
    if (majorString && majorString.length > 0) {
        major = @([majorString intValue]);
    }

    TYBeaconRegion *region = [TYBeaconRegion beaconRegionWithCityID:currentBuilding.cityID BuildingID:currentBuilding.buildingID Name:currentBuilding.name UUID:uuidString Major:major];
    
    NSLog(@"Region: %@", region);
    NSString *dbPath = [[TYMapEnvironment getRootDirectoryForMapFiles] stringByAppendingPathComponent:@"BeaconRegion.db"];
    TYBeaconRegionDBAdapter *db = [[TYBeaconRegionDBAdapter alloc] initWithPath:dbPath];
    [db open];
//    [db insertBeaconRegion:region];
//    [db insertBeaconRegions:@[region, region, region, region]];
    
    TYBeaconRegion *targetRegion = [db getBeaconRegion:currentBuilding.buildingID];
    if (targetRegion == nil) {
        [db insertBeaconRegion:region];
    } else {
        [db updateBeaconRegion:region];
    }
    [db close];

    [TYRegionManager reloadRegions];
}


- (IBAction)showRegionList:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BLE-Tool" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ShowBeaconRegionRootController"];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
