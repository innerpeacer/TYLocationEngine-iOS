#import "ShowPrimitiveBeaconTableVC.h"
#import "TYBeacon.h"
#import "TYPrimitiveBeaconDBAdapter.h"
#import "TYUserDefaults.h"

@interface ShowPrimitiveBeaconTableVC ()
{
    NSMutableArray *allPrimitiveBeacons;
    
    TYBuilding *currentBuiliding;
}
@end

@implementation ShowPrimitiveBeaconTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Titles";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    
    currentBuiliding  = [TYUserDefaults getDefaultBuilding];
    
    TYPrimitiveBeaconDBAdapter *db = [[TYPrimitiveBeaconDBAdapter alloc] initWithBuilding:currentBuiliding];
    [db open];
    NSArray *primitiveBeacons = [db getAllPrimitiveBeacons];
    [db close];
    
    NSArray *sorted = [primitiveBeacons sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        TYBeacon *b1 = (TYBeacon *)obj1;
        TYBeacon *b2 = (TYBeacon *)obj2;
        
        if (b1.major.intValue != b2.major.intValue) {
            return b1.major.intValue > b2.major.intValue;
        } else {
            return b1.minor.intValue > b2.minor.intValue;
        }
    }];
    
    allPrimitiveBeacons = [[NSMutableArray alloc] initWithArray:sorted];
 
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allPrimitiveBeacons.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TYPrimitiveBeaconDBAdapter *db = [[TYPrimitiveBeaconDBAdapter alloc] initWithBuilding:currentBuiliding];
        TYBeacon *beacon = [allPrimitiveBeacons objectAtIndex:indexPath.row];
        [db open];
        [db deletePrimitiveBeacon:beacon];
        [db close];
        
        [allPrimitiveBeacons removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    TYBeacon *beacon = [allPrimitiveBeacons objectAtIndex:indexPath.row];
    
    NSString *str = [NSString stringWithFormat:@"Major: %d, Minor: %d, Tag: %@", beacon.major.intValue, beacon.minor.intValue, beacon.tag];
    
    cell.textLabel.text = str;
    
    return cell;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
