#import "ConfigureBeaconsVC.h"

#import "BeaconListForChoosingTableVC.h"
#import <TYMapSDK/TYMapSDK.h>

#import "TYUserDefaults.h"
#import "NPBeaconFMDBAdapter.h"
#import "NPBeacon.h"
#import "AppConstants.h"
#import "NPBeaconManager.h"

#import "TYRegionManager.h"

@interface ConfigureBeaconsVC () <BeaconSelectedDelegate, NPBeaconManagerDelegate>
{
    TYGraphicsLayer *hintLayer;
    TYGraphicsLayer *publicBeaconLayer;
    
    NPBeacon *currentBeacon;
    TYLocalPoint *currentLocation;
    
    // ============================================
    NPBeaconManager *beaconManager;
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
}

- (void)initLocationManager
{
    beaconManager = [[NPBeaconManager alloc] init];
    beaconManager.delegate = self;
    
    beaconRegion = [TYRegionManager defaultRegion];
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

- (void)beaconManager:(NPBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (!isBinding) {
        return;
    }
    
    if (beacons.count == 0) {
        return;
    }
    
    NSLog(@"%d beacon ranged",(int) beacons.count);
    
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
        }
    }
    
    [sortedArray removeObjectsInArray:toRemove];
    
    CLBeacon *nearestBeacon = [sortedArray objectAtIndex:0];
    
    int currentRSSI = (int) nearestBeacon.rssi;
    
    if (currentRSSI > currentMaxRSSI) {
        currentMaxRSSI = currentRSSI;
        
        currentBeacon = [NPBeacon beaconWithUUID:nearestBeacon.proximityUUID.UUIDString Major:nearestBeacon.major Minor:nearestBeacon.minor Tag:[NSString stringWithFormat:@"%@", nearestBeacon.minor]];
        self.hintLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@, RSSI: %d", nearestBeacon.major, nearestBeacon.minor, (int)nearestBeacon.rssi];
    }

}

- (void)addLayers
{
    hintLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:hintLayer];
    
    publicBeaconLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:publicBeaconLayer];
}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(TYPoint *)mappoint
{
    [super TYMapView:mapView didClickAtPoint:screen mapPoint:mappoint];
    
    NSLog(@"Scale: %f", self.mapView.mapScale);
    NSLog(@"%f, %f", mappoint.x, mappoint.y);
    
    [hintLayer removeAllGraphics];
    [TYArcGISDrawer drawPoint:mappoint AtLayer:hintLayer WithColor:[UIColor greenColor]];
    
    currentLocation = [TYLocalPoint pointWithX:mappoint.x Y:mappoint.y Floor:self.currentMapInfo.floorNumber];;
    currentLocation.floor = self.currentMapInfo.floorNumber;
}

- (IBAction)addCurrentBeacon:(id)sender {
    if (currentLocation && currentBeacon) {
        
        NSNumber *major = currentBeacon.major;
        NSNumber *minor = currentBeacon.minor;
        NSString *tag = currentBeacon.tag;
        
        NPBeaconFMDBAdapter *pdb = [[NPBeaconFMDBAdapter alloc] initWithBuilding:self.currentBuilding];
        [pdb open];
        NPBeacon *pBeacon;
        
        pBeacon = [pdb getNephogramBeaconWithMajor:major Minor:minor];
        if (pBeacon == nil) {
            NPPublicBeacon *pb = [NPPublicBeacon beaconWithUUID:BEACON_SERVICE_UUID Major:major Minor:minor Tag:tag Location:currentLocation ShopGid:nil];
            [pdb insertNephogramBeacon:pb];
        } else {
            [pdb updateNephogramBeacon:[NPPublicBeacon beaconWithUUID:BEACON_SERVICE_UUID Major:major Minor:minor Tag:tag Location:currentLocation]];
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
    
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)didSelectBeacon:(NPBeacon *)beacon
{
    currentBeacon = beacon;
    
    self.hintLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@", currentBeacon.major, currentBeacon.minor];
}

- (IBAction)publicSwtichToggled:(id)sender {
    if (self.publicSwitch.on) {
        NPBeaconFMDBAdapter *db = [[NPBeaconFMDBAdapter alloc] initWithBuilding:self.currentBuilding];
        [db open];
        
        NSArray *array = [db getAllNephogramBeacons];
        NSLog(@"%d beacons", (int)array.count);
        
        for (NPPublicBeacon *pb in array)
        {
            if (pb.location.floor != self.currentMapInfo.floorNumber && pb.location.floor != 0) {
                continue;
            }
            
            TYPoint *p = [TYPoint pointWithX:pb.location.x y:pb.location.y spatialReference:self.mapView.spatialReference];
            
            [TYArcGISDrawer drawPoint:p AtLayer:publicBeaconLayer WithColor:[UIColor redColor]];

            
            AGSTextSymbol *ts = [AGSTextSymbol textSymbolWithText:[NSString stringWithFormat:@"%@", pb.minor] color:[UIColor magentaColor]];
            [ts setOffset:CGPointMake(5, -10)];
            [publicBeaconLayer addGraphic:[AGSGraphic graphicWithGeometry:p symbol:ts attributes:nil]];
        }
        [db close];
    } else {
        [publicBeaconLayer removeAllGraphics];
    }
}

- (IBAction)showConfiguredBeacons:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BLE-Tool" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"showConfiguredBeaconsRootController"];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
