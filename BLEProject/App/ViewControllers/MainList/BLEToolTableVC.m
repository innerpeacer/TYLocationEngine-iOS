#import "BLEToolTableVC.h"

@implementation BLEToolTableVC

- (void)viewDidLoad
{
    
    self.objects = [[NSMutableArray alloc] init];
    self.controllerDict = [[NSMutableDictionary alloc] init];
    
    self.title = @"BLE工具";

   
    [self.objects addObject:@"商场地图"];
    [self.controllerDict setObject:@"mapViewController" forKey:@"商场地图"];
    
    [self.objects addObject:@"添加原始信标"];
    [self.controllerDict setObject:@"addPrimitiveController" forKey:@"添加原始信标"];
    
    [self.objects addObject:@"配置信标"];
    [self.controllerDict setObject:@"configureBeaconController" forKey:@"配置信标"];
    
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
