#import "BuildingTableVC.h"
#import <TYMapSDK/TYMapSDK.h>

#import "FloorMapVC.h"

@interface BuildingTableVC ()
{
    NSArray *allBuilding;
}

@end

@implementation BuildingTableVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"商场列表";
    
    allBuilding = [[NSArray alloc] init];
    if (self.currentCity) {
        allBuilding = [TYBuilding parseAllBuildings:self.currentCity];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allBuilding count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    TYBuilding *building = [allBuilding objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", building.name, building.buildingID];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showFloorMap"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TYBuilding *building = [allBuilding objectAtIndex:indexPath.row];
                
        FloorMapVC *floorMapViewController = [segue destinationViewController];
        floorMapViewController.currentBuilding = building;
    }
}


@end
