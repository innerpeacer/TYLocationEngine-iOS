//
//  RawDataTableVC.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/10.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "RawDataTableVC.h"
#import "TYRawDataManager.h"
#import "PDRSimulatorVC.h"
#import "FusionPDRSimulatorVC.h"
#import "TestCppPbfVC.h"

@interface RawDataTableVC ()
{
    TYRawDataManager *manager;
    NSMutableArray *dataArray;
}
@end

@implementation RawDataTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"原始数据列表";
    dataArray = [NSMutableArray arrayWithArray:[TYRawDataManager getAllDataID]];
    
//    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dataID = dataArray[indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BLE-Algorithm" bundle:nil];
//    PDRSimulatorVC *controller = [storyboard instantiateViewControllerWithIdentifier:@"PDRSimulatorVC"];
//    controller.dataID = dataID;
    
    FusionPDRSimulatorVC *controller = [storyboard instantiateViewControllerWithIdentifier:@"FusionPDRSimulatorVC"];
//    TestCppPbfVC *controller = [storyboard instantiateViewControllerWithIdentifier:@"TestCppPbfVC"];
    controller.dataID = dataID;
    [self.navigationController pushViewController:controller animated:NO];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"rawDataIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    cell.textLabel.text = dataArray[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *dataID = dataArray[indexPath.row];
        [TYRawDataManager deleteData:dataID];
        [dataArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

@end
