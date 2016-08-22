#import "ConfigureBeaconsVC.h"

#import "BeaconListForChoosingTableVC.h"
#import <TYMapSDK/TYMapSDK.h>

#import "TYUserDefaults.h"
#import "TYBeaconFMDBAdapter.h"
#import "TYBeacon.h"
#import "TYBeaconManager.h"

#import "TYRegionManager.h"
#import "IPBeaconDBCodeChecker.h"
#import "TYMapToFengMap.h"

@interface ConfigureBeaconsVC () <BeaconSelectedDelegate, TYBeaconManagerDelegate>
{
    AGSGraphicsLayer *hintLayer;
    AGSGraphicsLayer *publicBeaconLayer;
    
    TYBeacon *currentBeacon;
    TYLocalPoint *currentLocation;
    
    // ============================================
    TYBeaconManager *beaconManager;
    int currentMaxRSSI;
    CLBeaconRegion *beaconRegion;
    BOOL isBinding;
}

@property (weak, nonatomic) IBOutlet UISwitch *publicSwitch;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (weak, nonatomic) IBOutlet UIButton *bindingButton;

- (IBAction)bindingButtonClicked:(id)sender;
- (IBAction)addCurrentBeacon:(id)sender;
- (IBAction)chooseBeacon:(id)sender;

- (IBAction)publicSwtichToggled:(id)sender;
- (IBAction)showConfiguredBeacons:(id)sender;

@end

@implementation ConfigureBeaconsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initLocationManager];
    isBinding = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Beacon List" style:UIBarButtonItemStylePlain target:self action:@selector(showConfiguredBeacons:)];
    
    [self addLayers];
    
    [self.mapView setBackgroundColor:[UIColor whiteColor]];
}

- (void)initLocationManager
{
    beaconManager = [[TYBeaconManager alloc] init];
    beaconManager.delegate = self;
    
    beaconRegion =  [TYRegionManager getBeaconRegionForBuilding:[TYUserDefaults getDefaultBuilding].buildingID].region;
    
        NSLog(@"%@", [TYUserDefaults getDefaultBuilding]);
        NSLog(@"%@", beaconRegion);
}

- (IBAction)bindingButtonClicked:(id)sender {
    if (isBinding) {
        [self.bindingButton setTitle:@"绑定最近Beacon" forState:UIControlStateNormal];
        [self stopBinding];
    } else {
        [self.bindingButton setTitle:@"停止绑定" forState:UIControlStateNormal];
        [self startBinding];
    }
    
}

- (void)startBinding
{
    NSLog(@"Start Binding");
    isBinding = YES;
    
    [beaconManager startRanging:beaconRegion];
    
    currentMaxRSSI = -100;
}

- (void)stopBinding
{
    NSLog(@"Stop Binding");
    isBinding = NO;
    
    [beaconManager stopRanging:beaconRegion];
    self.hintLabel.text = @"";
    currentBeacon = nil;
    
    currentMaxRSSI = -100;
}

- (void)beaconManager:(TYBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (!isBinding) {
        return;
    }
    
    if (beacons.count == 0) {
        return;
    }
    
    NSLog(@"%d beacon ranged", (int)beacons.count);
    
    
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:[beacons sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CLBeacon *b1 = (CLBeacon *)obj1;
        CLBeacon *b2 = (CLBeacon *)obj2;
        
        NSNumber *l1 = [NSNumber numberWithDouble:b1.rssi];
        NSNumber *l2 = [NSNumber numberWithDouble:b2.rssi];
        return ![l1 compare:l2];
    }]];
    
    
    NSMutableArray *toRemove = [[NSMutableArray alloc] init];
    for (CLBeacon *b in sortedArray) {
        if (b.rssi >= -10) {
            [toRemove addObject:b];
            NSLog(@"RSSI: %d", (int)b.rssi);
            NSLog(@"Accuracy: %f", b.accuracy);
        }
    }
    
    [sortedArray removeObjectsInArray:toRemove];
    
    if (sortedArray.count == 0) {
        return;
    }
    
    CLBeacon *nearestBeacon = [sortedArray objectAtIndex:0];
    
    int currentRSSI = (int) nearestBeacon.rssi;
    
    if (currentRSSI > currentMaxRSSI) {
        currentMaxRSSI = currentRSSI;
        
        currentBeacon = [TYBeacon beaconWithUUID:nearestBeacon.proximityUUID.UUIDString Major:nearestBeacon.major Minor:nearestBeacon.minor Tag:[NSString stringWithFormat:@"%@", nearestBeacon.minor]];
        self.hintLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@, RSSI: %d", nearestBeacon.major, nearestBeacon.minor, (int)nearestBeacon.rssi];
    }
    
}

- (void)addLayers
{
    hintLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:hintLayer];
    
    publicBeaconLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:publicBeaconLayer];
}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
{
    [super TYMapView:mapView didClickAtPoint:screen mapPoint:mappoint];
    
    NSLog(@"Scale: %f", self.mapView.mapScale);
    NSLog(@"%f, %f", mappoint.x, mappoint.y);
    
    [hintLayer removeAllGraphics];
    [TYArcGISDrawer drawPoint:mappoint AtLayer:hintLayer WithColor:[UIColor greenColor]];
    
    currentLocation = [TYLocalPoint pointWithX:mappoint.x Y:mappoint.y Floor:self.currentMapInfo.floorNumber];;
    currentLocation.floor = self.currentMapInfo.floorNumber;
    
    
//    // Convert Beacon Data to Feng Map
//    {
//        TYBeaconFMDBAdapter *pdb = [[TYBeaconFMDBAdapter alloc] initWithBuilding:self.currentBuilding];
//        [pdb open];
//        NSArray *beaconArray = [pdb getAllLocationingBeacons];
//        for(TYPublicBeacon *pb in beaconArray)
//        {
//            NSArray *fengArray = [TYMapToFengMap TYMapToFengMap:@[@(pb.location.x), @(pb.location.y)]];
//            TYLocalPoint *fengLocation = [TYLocalPoint pointWithX:[fengArray[0] doubleValue] Y:[fengArray[1] doubleValue] Floor:pb.location.floor];
//            [pdb updateLocationingBeacon:[TYPublicBeacon beaconWithUUID:beaconRegion.proximityUUID.UUIDString Major:pb.major Minor:pb.minor Tag:pb.tag Location:fengLocation]];
//        }
//        [pdb close];
//    }


}

- (IBAction)addCurrentBeacon:(id)sender {
    if (currentLocation && currentBeacon) {
        
        NSNumber *major = currentBeacon.major;
        NSNumber *minor = currentBeacon.minor;
        NSString *tag = currentBeacon.tag;
        
        TYBeaconFMDBAdapter *pdb = [[TYBeaconFMDBAdapter alloc] initWithBuilding:self.currentBuilding];
        [pdb open];
        TYBeacon *pBeacon;
        
        pBeacon = [pdb getLocationingBeaconWithMajor:major Minor:minor];
        if (pBeacon == nil) {
            TYPublicBeacon *pb = [TYPublicBeacon beaconWithUUID:beaconRegion.proximityUUID.UUIDString Major:major Minor:minor Tag:tag Location:currentLocation ShopGid:nil];
            [pdb insertLocationingBeacon:pb];
        } else {
            [pdb updateLocationingBeacon:[TYPublicBeacon beaconWithUUID:beaconRegion.proximityUUID.UUIDString Major:major Minor:minor Tag:tag Location:currentLocation]];
        }
        [pdb close];
        
        currentBeacon = nil;
        self.hintLabel.text = @"";
        
        if (isBinding) {
            [self.bindingButton setTitle:@"绑定最近Beacon" forState:UIControlStateNormal];
            [self stopBinding];
        }
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Location or Beacon is nil" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)chooseBeacon:(id)sender {
    NSString *identifier = @"beaconListController";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BLE-Tool" bundle:nil];
    BeaconListForChoosingTableVC *controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
    controller.delegate = self;
    
    //    [self presentViewController:controller animated:YES completion:nil];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:nil];
    
}


- (void)didSelectBeacon:(TYBeacon *)beacon
{
    currentBeacon = beacon;
    
    self.hintLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@", currentBeacon.major, currentBeacon.minor];
}

- (IBAction)publicSwtichToggled:(id)sender {
    if (self.publicSwitch.on) {
        TYBeaconFMDBAdapter *db = [[TYBeaconFMDBAdapter alloc] initWithBuilding:self.currentBuilding];
        [db open];
        
        NSArray *array = [db getAllLocationingBeacons];
        NSLog(@"%d beacons", (int)array.count);
        
        if (array && array.count > 0) {
            NSString *code = [IPBeaconDBCodeChecker checkBeacons:array];
            if ([db getCheckCode]) {
                [db updateCheckCode:code];
            } else {
                [db insertCheckCode:code];
            }
        }
        
        for (TYPublicBeacon *pb in array)
        {
//            printf("%s\t%d\t%d\t%f\t%f\t%d\n", [pb.UUID UTF8String], pb.major.intValue, pb.minor.intValue, pb.location.x, pb.location.y, pb.location.floor);

            if (pb.location.floor != self.currentMapInfo.floorNumber && pb.location.floor != 0) {
                continue;
            }
            
            //            NSLog(@"Tag: %@", pb.tag);
            AGSPoint *p = [AGSPoint pointWithX:pb.location.x y:pb.location.y spatialReference:self.mapView.spatialReference];
            
            [TYArcGISDrawer drawPoint:p AtLayer:publicBeaconLayer WithColor:[UIColor redColor]];
            
            
            AGSTextSymbol *ts = [AGSTextSymbol textSymbolWithText:[NSString stringWithFormat:@"%@", pb.minor] color:[UIColor magentaColor]];
            [ts setOffset:CGPointMake(5, -10)];
            [publicBeaconLayer addGraphic:[AGSGraphic graphicWithGeometry:p symbol:ts attributes:nil]];
            
            // For Doubi Wanda
//            NSLog(@"%d\t%f\t%f", pb.minor.intValue, pb.location.x, pb.location.y);
//            printf("%d\t%f\t%f\n", pb.minor.intValue, pb.location.x, pb.location.y);
            

//            printf("TY  :\t%d\t%f\t%f\n", pb.minor.intValue, pb.location.x, pb.location.y);
//            NSArray *fengArray = [TYMapToFengMap TYMapToFengMap:@[@(pb.location.x), @(pb.location.y)]];
//            printf("Feng:\t%d\t%f\t%f\n", pb.minor.intValue, [fengArray[0] doubleValue], [fengArray[1] doubleValue]);
           
        }
        [db close];
        
        //        NSLog(@"%@", array);
        [self encodeBeaconArrayToJson:array];
        [self encodeBeaconJsonForServer:array];
    } else {
        [publicBeaconLayer removeAllGraphics];
    }
}

- (void)encodeBeaconArrayToJson:(NSArray *)array
{
    NSMutableDictionary *rootDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *beaconArray = [[NSMutableArray alloc] init];
    
    [rootDict setObject:beaconArray forKey:@"beacons"];
    
    for (TYPublicBeacon *pb in array) {
        NSMutableDictionary *beaconDict = [[NSMutableDictionary alloc] init];
        [beaconDict setObject:pb.UUID forKey:@"uuid"];
        [beaconDict setObject:pb.major forKey:@"major"];
        [beaconDict setObject:pb.minor forKey:@"minor"];
        [beaconDict setObject:@(pb.location.x) forKey:@"x"];
        [beaconDict setObject:@(pb.location.y) forKey:@"y"];
        [beaconDict setObject:@(pb.location.floor) forKey:@"floor"];
        
        [beaconArray addObject:beaconDict];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:rootDict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"beacon.json"];
    NSLog(@"%@", documentDirectory);
    [data writeToFile:path atomically:YES];
}

- (void)encodeBeaconJsonForServer:(NSArray *)array
{
    NSMutableDictionary *rootDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *beaconArray = [[NSMutableArray alloc] init];
    
    [rootDict setObject:beaconArray forKey:@"beacons"];
    
    for (TYPublicBeacon *pb in array) {
        NSMutableDictionary *beaconDict = [[NSMutableDictionary alloc] init];
        [beaconDict setObject:pb.UUID forKey:@"uuid"];
        [beaconDict setObject:pb.major forKey:@"major"];
        [beaconDict setObject:pb.minor forKey:@"minor"];
        [beaconDict setObject:@(pb.location.x) forKey:@"x"];
        [beaconDict setObject:@(pb.location.y) forKey:@"y"];
        [beaconDict setObject:@(pb.location.floor) forKey:@"floor"];
        
        [beaconDict setObject:self.currentBuilding.cityID forKey:@"cityID"];
        [beaconDict setObject:self.currentBuilding.buildingID forKey:@"buildingID"];
        for (TYMapInfo *info in self.allMapInfos) {
            if (info.floorNumber == pb.location.floor) {
                [beaconDict setObject:info.mapID forKey:@"mapID"];
            }
        }
        
        [beaconArray addObject:beaconDict];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:rootDict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"beaconForServer.json"];
    NSLog(@"%@", documentDirectory);
    [data writeToFile:path atomically:YES];
}

- (IBAction)showConfiguredBeacons:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BLE-Tool" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"showConfiguredBeaconsRootController"];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
