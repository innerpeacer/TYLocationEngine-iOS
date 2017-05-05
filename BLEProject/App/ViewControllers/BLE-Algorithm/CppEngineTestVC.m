#import "CppEngineTestVC.h"
#import "TYBeaconFMDBAdapter.h"

#import <TYMapSDK/TYMapSDK.h>

#import "TYLocationManager.h"
#import "TYRegionManager.h"
#import "TYUserDefaults.h"
#import "LocationTestHelper.h"

@interface CppEngineTestVC () <TYLocationManagerDelegate>
{
    CLBeaconRegion *publicBeaconRegion;
    TYLocationManager *locationManager;
}
@end

@implementation CppEngineTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLocationSettings];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (publicBeaconRegion) {
        [locationManager startUpdateLocation];
        locationManager.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (publicBeaconRegion) {
        [locationManager stopUpdateLocation];
        locationManager.delegate = nil;
    }
}


- (void)initLocationSettings
{
    publicBeaconRegion = [TYRegionManager getBeaconRegionForBuilding:[TYUserDefaults getDefaultBuilding].buildingID].region;
    locationManager = [[TYLocationManager alloc] initWithBuilding:[TYUserDefaults getDefaultBuilding]];
    [locationManager setLimitBeaconNumber:YES];
    [locationManager setRssiThreshold:-90];
        locationManager.delegate = self;
    [locationManager setBeaconRegion:publicBeaconRegion];
}

- (void)TYLocationManager:(TYLocationManager *)manager didUpdateLocation:(TYLocalPoint *)newLocation
{
    NSLog(@"%@", [newLocation description]);
    [self.locationLayer1 removeAllGraphics];
    
    if (newLocation.floor != self.mapView.currentMapInfo.floorNumber) {
        [self.mapView setFloorWithInfo:[TYMapInfo searchMapInfoFromArray:self.allMapInfos Floor:newLocation.floor]];
        self.title = self.mapView.currentMapInfo.floorName;
    }
    [self.mapView showLocation:newLocation];
}

- (void)TYLocationManager:(TYLocationManager *)manager didUpdateImmediateLocation:(TYLocalPoint *)newImmediateLocation
{
//    NSLog(@"%@", [newImmediateLocation description]);
//    [self.locationLayer1 removeAllGraphics];
//    
//    if (newImmediateLocation.floor != self.mapView.currentMapInfo.floorNumber) {
//        [self.mapView setFloorWithInfo:[TYMapInfo searchMapInfoFromArray:self.allMapInfos Floor:newImmediateLocation.floor]];
//        self.title = self.mapView.currentMapInfo.floorName;
//    }
//    [self.mapView showLocation:newImmediateLocation];
}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
{
    NSLog(@"didClickAtPoint: %f, %f", mappoint.x, mappoint.y);
    NSLog(@"%f", self.mapView.mapScale);
}

- (void)TYLocationManager:(TYLocationManager *)manager didUpdateDeviceHeading:(double)newHeading
{
    [self.mapView processDeviceRotation:newHeading];
}

- (void)TYLocationManagerdidFailUpdateLocation:(TYLocationManager *)manager
{
    [self.mapView removeLocation];
}

- (void)TYLocationManager:(TYLocationManager *)manager didRangedBeacons:(NSArray *)beacons
{
}

- (void)TYLocationManager:(TYLocationManager *)manager didRangedLocationBeacons:(NSArray *)beacons
{
    [self.signalLayer removeAllGraphics];
    if (self.isSignalOn) {
        [LocationTestHelper showHintRssiForLocationBeacons:beacons WithMapInfo:self.currentMapInfo OnLayer:self.signalLayer];
    } else {
        [self.signalLayer removeAllGraphics];
    }
}


@end
