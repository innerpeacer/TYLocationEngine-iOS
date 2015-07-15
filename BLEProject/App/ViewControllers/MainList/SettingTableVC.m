#import "SettingTableVC.h"

#import "TYBuildingMonitor.h"

@implementation SettingTableVC

- (void)viewDidLoad
{    
    self.objects = [[NSMutableArray alloc] init];
    self.controllerDict = [[NSMutableDictionary alloc] init];
    
    self.title = @"设置";

    
    [self.objects addObject:@"设置当前建筑"];
    [self.controllerDict setObject:@"setPlaceController" forKey:@"设置当前建筑"];
    
//    [self.objects addObject:@"重置定点测试数据"];
//    [self.controllerDict setObject:@"resetPointTestController" forKey:@"重置定点测试数据"];
    
    NSLog(@"monitor");
    TYBuildingMonitor *monitor = [[TYBuildingMonitor alloc] init];
    [monitor start];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.objects objectAtIndex:indexPath.row];
    
    if ([self.controllerDict objectForKey:key] != nil) {
        NSString *identifier = [self.controllerDict objectForKey:key];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
