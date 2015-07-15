#import "MapTableVC.h"

@implementation MapTableVC

- (void)viewDidLoad
{    
    self.objects = [[NSMutableArray alloc] init];
    self.controllerDict = [[NSMutableDictionary alloc] init];
    
    self.title = @"地图";
    
    [self.objects addObject:@"ArcGIS地图"];
    [self.controllerDict setObject:@"cityListController" forKey:@"ArcGIS地图"];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.objects objectAtIndex:indexPath.row];
    
    if ([self.controllerDict objectForKey:key] != nil) {
        NSString *identifier = [self.controllerDict objectForKey:key];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
