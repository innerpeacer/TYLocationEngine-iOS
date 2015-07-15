#import "BLEAlgorithmTableVC.h"

@implementation BLEAlgorithmTableVC

- (void)viewDidLoad
{
    self.objects = [[NSMutableArray alloc] init];
    self.controllerDict = [[NSMutableDictionary alloc] init];
    
    self.title = @"BLE算法";
    
    [self.objects addObject:@"Base Location Test"];
    [self.controllerDict setObject:@"baseLocatingController" forKey:@"Base Location Test"];
    
    [self.objects addObject:@"Location Engine Test"];
    [self.controllerDict setObject:@"locationEngineTestController" forKey:@"Location Engine Test"];
    
    [self.objects addObject:@"Multi Location Engine Test"];
    [self.controllerDict setObject:@"multiTestController" forKey:@"Multi Location Engine Test"];
    
    [self.objects addObject:@"Beacon Filter 测试"];
    [self.controllerDict setObject:@"beaconFilterController" forKey:@"Beacon Filter 测试"];
    
    [self.objects addObject:@"Cpp Engine 测试"];
    [self.controllerDict setObject:@"cppEngineController" forKey:@"Cpp Engine 测试"];
    
    [self.objects addObject:@"Cpp Engine 对比测试"];
    [self.controllerDict setObject:@"cppEngineCompareController" forKey:@"Cpp Engine 对比测试"];
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
