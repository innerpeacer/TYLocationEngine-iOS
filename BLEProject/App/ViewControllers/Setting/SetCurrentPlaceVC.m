#import "SetCurrentPlaceVC.h"
#import "TYUserDefaults.h"

#import <TYMapSDK/TYMapSDK.h>


#define CITY_PICKER 0
#define BUILDING_PICKER 1

@interface SetCurrentPlaceVC ()
{
    NSArray *cityArray;

    int currentCityIndex;
    NSMutableArray *buildingArray;
    
    NSString *currentCityID;
    NSString *currentBuildingID;
}
@end

@implementation SetCurrentPlaceVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    cityArray = [TYCityManager parseAllCities];

    TYBuilding *building = [TYUserDefaults getDefaultBuilding];
    self.title = [NSString stringWithFormat:@"当前建筑：%@", building.name];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == CITY_PICKER) {
        return [cityArray count];
    }

    return [buildingArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (component == CITY_PICKER) {
        TYCity *city = [cityArray objectAtIndex:row];
        return city.name;
    }

    TYBuilding *building = [buildingArray objectAtIndex:row];
    return building.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if (component == CITY_PICKER) {
        TYCity *selectedCity = [cityArray objectAtIndex:row];
        buildingArray = [NSMutableArray arrayWithArray:[TYBuildingManager parseAllBuildings:selectedCity]];

        [pickerView selectRow:0 inComponent:BUILDING_PICKER animated:YES];
        [pickerView reloadComponent:BUILDING_PICKER];
        
        currentCityID = selectedCity.cityID;
        
    } else {
        TYBuilding *building = [buildingArray objectAtIndex:row];
        currentBuildingID = building.buildingID;
    }

}
- (IBAction)chooseBuilding:(id)sender {
    
    if (currentCityID && currentBuildingID) {
        
        [TYUserDefaults setDefaultCity:currentCityID];
        [TYUserDefaults setDefaultBuilding:currentBuildingID];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"City or Building not selected!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
