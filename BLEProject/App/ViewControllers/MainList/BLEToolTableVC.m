#import "BLEToolTableVC.h"

@implementation BLEToolTableVC

- (void)viewDidLoad
{
    self.title = @"BLE工具";
    
    NSArray *viewControllers = @[
                                 @[@"商场地图", @"mapViewController"],
                                 @[@"添加原始信标", @"addPrimitiveController"],
                                 @[@"配置信标", @"configureBeaconController"],
                                 @[@"验证Beacon数据", @"CheckBeaconDatabaseVC"],
                                 @[@"上传Beacon数据", @"UploadBeaconVC"],
                                                                  ];
    
    self.objects = [[NSMutableArray alloc] init];
    self.controllerDict = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < viewControllers.count; ++i) {
        NSArray *controller = viewControllers[i];
        NSString *name = [NSString stringWithFormat:@"%d. %@",i, controller[0]];
        NSString *storyboardID = controller[1];
        [self.objects addObject:name];
        [self.controllerDict setObject:storyboardID forKey:name];
    }
    
    
//    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.objects objectAtIndex:indexPath.row];
    
    if ([self.controllerDict objectForKey:key] != nil) {
        NSString *identifier = [self.controllerDict objectForKey:key];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BLE-Tool" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
