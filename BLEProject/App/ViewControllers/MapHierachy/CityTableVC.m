#import "CityTableVC.h"

#import <TYMapSDK/TYMapSDK.h>

#import "BuildingTableVC.h"

@interface CityTableVC ()
{
    NSArray *allCities;
}

@end

@implementation CityTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"城市列表";
    
    allCities = [TYCityManager parseAllCities];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allCities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    TYCity *city = [allCities objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", city.name, city.cityID];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showBuildings"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TYCity *city = [allCities objectAtIndex:indexPath.row];
        
        BuildingTableVC *buildingListController = [segue destinationViewController];
        buildingListController.currentCity = city;
    }
}

@end
