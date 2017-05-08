//
//  TraceTableVC.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/8.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TraceTableVC.h"
#import "TraceManager.h"
#import "BaseLocationTestVC.h"

@interface TraceTableNaviController()
{
    TraceTableVC *tableVC;
}

@end

@implementation TraceTableNaviController

- (id)init
{
    tableVC = [[TraceTableVC alloc] initWithStyle:UITableViewStylePlain];
    self = [super initWithRootViewController:tableVC];
    if (self) {
        
    }
    return self;
}

- (void)setStartingController:(UIViewController *)startingController
{
    _startingController = startingController;
    tableVC.startingController = startingController;
}

@end

@interface TraceTableVC ()
{
    TraceManager *manager;
    NSMutableArray *traceArray;
}
@end

@implementation TraceTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Traces";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss:)];
    traceArray = [NSMutableArray arrayWithArray:[TraceManager getTraces]];
}

- (IBAction)dismiss:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == traceArray.count) {
        [TraceManager deleteAllTraces];
    } else {
        [TraceManager setCurrentTrace:traceArray[indexPath.row]];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        BaseLocationTestVC *controller = (BaseLocationTestVC *)self.startingController;
        [controller tableViewFinished];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return traceArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"traceIdentifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (indexPath.row == traceArray.count) {
        cell.textLabel.text = @"删除所有轨迹";
    } else {
        TYTrace *trace = traceArray[indexPath.row];
        cell.textLabel.text = trace.traceID;
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == traceArray.count) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TYTrace *trace = traceArray[indexPath.row];
        [TraceManager deleteTrace:trace.traceID];
        [traceArray removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}



@end
