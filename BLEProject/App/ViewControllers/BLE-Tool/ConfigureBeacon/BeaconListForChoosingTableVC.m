#import "BeaconListForChoosingTableVC.h"
#import "TYPrimitiveBeaconDBAdapter.h"
#import "TYUserDefaults.h"

@interface BeaconListForChoosingTableVC ()
{
    NSArray *beacons;
    TYBuilding *currentBuilding;
}
@end

@implementation BeaconListForChoosingTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"待配置Beacon";
    
    currentBuilding = [TYUserDefaults getDefaultBuilding];
    
    TYPrimitiveBeaconDBAdapter *db = [[TYPrimitiveBeaconDBAdapter alloc] initWithBuilding:currentBuilding];
    [db open];
    NSArray *primitiveBeacons = [db getAllPrimitiveBeacons];
    [db close];
    
    beacons = [primitiveBeacons sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        TYBeacon *b1 = (TYBeacon *)obj1;
        TYBeacon *b2 = (TYBeacon *)obj2;
        
        if (b1.major.intValue != b2.major.intValue) {
            return b1.major.intValue > b2.major.intValue;
        } else {
            return b1.minor.intValue > b2.minor.intValue;
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (beacons.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (self.delegate) {
        TYBeacon *beacon = [beacons objectAtIndex:indexPath.row];
        [self.delegate didSelectBeacon:beacon];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"选择信标:";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return beacons.count == 0 ? 1: beacons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (beacons.count == 0) {
        cell.textLabel.text = @"当前没有信标";
        return cell;
    }
    
    TYBeacon *beacon = [beacons objectAtIndex:indexPath.row];
    
    NSString *str = [NSString stringWithFormat:@"Major: %d, Minor: %d, Tag: %@", beacon.major.intValue, beacon.minor.intValue, beacon.tag];
    cell.textLabel.text = str;
    
    return cell;
}

@end
