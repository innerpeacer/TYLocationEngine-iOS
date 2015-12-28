//
//  ShowPointPositionTableVC.m
//  BLEProject
//
//  Created by innerpeacer on 15/12/1.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "ShowPointPositionTableVC.h"
#import "TYPointPosition.h"
#import "TYPointPosFMDBAdapter.h"
#import "TYUserDefaults.h"
#import <TYMapData/TYMapData.h>

@interface ShowPointPositionTableVC ()
{
    TYBuilding *currentBuilding;

    NSMutableArray *allPointPositions;
}

@end

@implementation ShowPointPositionTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"点位列表";
    
    [self fetchData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
}


- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fetchData
{
    currentBuilding = [TYUserDefaults getDefaultBuilding];

    TYPointPosFMDBAdapter *db = [[TYPointPosFMDBAdapter alloc] initWithBuilding:currentBuilding];
    [db open];
    allPointPositions = [NSMutableArray arrayWithArray:[db getAllPointPositions]];
    [allPointPositions sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        TYPointPosition *p1 = obj1;
        TYPointPosition *p2 = obj2;
        return (p1.tag < p2.tag);
    }];
    [db close];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"点位列表";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allPointPositions count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TYPointPosFMDBAdapter *db = [[TYPointPosFMDBAdapter alloc] initWithBuilding:currentBuilding];
        [db open];
        [db deletePointPosition:allPointPositions[indexPath.row]];
        [db close];
        
        [allPointPositions removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    TYPointPosition *pp = allPointPositions[indexPath.row];
    NSString *content = [NSString stringWithFormat:@"%d: (%.2f, %.2f, %d)", pp.tag, pp.location.x, pp.location.y, pp.location.floor];
    cell.textLabel.text = content;
    
    return cell;
}


@end
