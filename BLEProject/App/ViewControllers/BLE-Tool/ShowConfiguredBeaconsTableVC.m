#import "ShowConfiguredBeaconsTableVC.h"
#import "TYBeaconFMDBAdapter.h"
#import "TYUserDefaults.h"
#import "TYBeaconFMDBAdapter.h"

@interface ShowConfiguredBeaconsTableVC ()
{
    NSMutableArray *groups;
    NSMutableArray *groupTitles;
    
    TYBuilding *currentBuilding;
}

@end

@implementation ShowConfiguredBeaconsTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Beacon列表";

    [self fetchData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fetchData
{
    groups = [[NSMutableArray alloc] init];
    groupTitles = [[NSMutableArray alloc] init];
    
    currentBuilding = [TYUserDefaults getDefaultBuilding];
    
    TYBeaconFMDBAdapter *db = [[TYBeaconFMDBAdapter alloc] initWithBuilding:currentBuilding];
    [db open];
    
    NSArray *publicArray = [db getAllLocationingBeacons];
    if (publicArray.count > 0) {
        
        publicArray = [publicArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            TYBeacon *b1 = (TYBeacon *)obj1;
            TYBeacon *b2 = (TYBeacon *)obj2;
            
            if (b1.major.intValue != b2.major.intValue) {
                return b1.major.intValue > b2.major.intValue;
            } else {
                return b1.minor.intValue > b2.minor.intValue;
            }
        }];
        
        [groups addObject:[NSMutableArray arrayWithArray:publicArray]];
        [groupTitles addObject:@"Beacons"];
    }
    
    [db close];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return groupTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [groupTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[groups objectAtIndex:section] count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        TYBeaconFMDBAdapter *db = [[TYBeaconFMDBAdapter alloc] initWithBuilding:currentBuilding];
        [db open];
        
        TYBeacon *beacon = [[groups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if ([[groupTitles objectAtIndex:indexPath.section] isEqualToString:@"Beacons"]) {
            [db deleteLocationingBeaconWithMajor:beacon.major.intValue Minor:beacon.minor.intValue];
        }
        
        [[groups objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [db close];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
       
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    TYBeacon *beacon = [[groups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *str;
    
    if (beacon.type == PUBLIC) {
        TYPublicBeacon *pb = (TYPublicBeacon *)beacon;
       
        str = [NSString stringWithFormat:@"Major: %d, Minor: %d, Floor: %d", pb.major.intValue, pb.minor.intValue, pb.location.floor];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f, %.2f", pb.location.x, pb.location.y];
    } else {
        str = [NSString stringWithFormat:@"Major: %d, Minor: %d", beacon.major.intValue, beacon.minor.intValue];
    }
    cell.textLabel.text = str;
    
    return cell;
}

@end
