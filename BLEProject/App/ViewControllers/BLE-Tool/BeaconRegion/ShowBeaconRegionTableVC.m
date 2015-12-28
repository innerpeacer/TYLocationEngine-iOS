//
//  ConfigureBeaconRegionTableVC.m
//  BLEProject
//
//  Created by innerpeacer on 15/12/27.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "ShowBeaconRegionTableVC.h"
#import <TYMapSDK/TYMapSDK.h>
#import "TYBeaconRegionDBAdapter.h"
#import "TYBeaconRegion.h"
#import "TYRegionManager.h"

@interface ShowBeaconRegionTableVC()
{
    NSMutableArray *allBeaconRegions;
    NSString *dbPath;
}

@end

@implementation ShowBeaconRegionTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"BeaconRegion列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    dbPath = [[TYMapEnvironment getRootDirectoryForMapFiles] stringByAppendingPathComponent:@"BeaconRegion.db"];
    [self readRegionData];
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)readRegionData
{
    TYBeaconRegionDBAdapter *db = [[TYBeaconRegionDBAdapter alloc] initWithPath:dbPath];
    [db open];
    allBeaconRegions = [NSMutableArray arrayWithArray:[db getAllBeaconRegions]];
    [db close];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allBeaconRegions count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TYBeaconRegionDBAdapter *db = [[TYBeaconRegionDBAdapter alloc] initWithPath:dbPath];
        [db open];
        TYBeaconRegion *targetRegion = allBeaconRegions[indexPath.row];
        [db deleteBeaconRegion:targetRegion.buildingID];
        [db close];
        
        [allBeaconRegions removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
        [TYRegionManager reloadRegions];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    TYBeaconRegion *br = allBeaconRegions[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@", br.name, br.buildingID];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"UUID: %@, Major: %@", br.region.proximityUUID.UUIDString, br.region.major];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:10.0f];
    
    return cell;
}

@end
