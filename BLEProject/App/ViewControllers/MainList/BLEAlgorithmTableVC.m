#import "BLEAlgorithmTableVC.h"

@implementation BLEAlgorithmTableVC

- (void)viewDidLoad
{
    self.title = @"BLE算法";

    NSArray *viewControllers = @[
                                @[@"Base Location Test",@"baseLocatingController"],
                                @[@"Location Engine Test",@"locationEngineTestController"],
                                @[@"Multi Location Engine Test",@"multiTestController"],
                                @[@"Beacon Filter 测试",@"beaconFilterController"],
                                @[@"Cpp Engine 测试",@"cppEngineController"],
                                @[@"Cpp Engine 对比测试",@"cppEngineCompareController" ],
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

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.objects objectAtIndex:indexPath.row];
    
    if ([self.controllerDict objectForKey:key] != nil) {
        NSString *identifier = [self.controllerDict objectForKey:key];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BLE-Algorithm" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
