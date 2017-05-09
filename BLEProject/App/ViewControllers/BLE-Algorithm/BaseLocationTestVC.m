//
//  BaseLocationTestVC.m
//  BLEProject
//
//  Created by innerpeacer on 2017/4/30.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "BaseLocationTestVC.h"
#import "TYRegionManager.h"
#import "TYUserDefaults.h"

@interface BaseLocationTestVC () <UIActionSheetDelegate>

@end

@implementation BaseLocationTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLocationSettings];

    self.publicBeaconLayer = [ArcGISHelper createNewLayer:self.mapView];
    self.traceLayer1 = [ArcGISHelper createNewLayer:self.mapView];
    self.traceLayer2 = [ArcGISHelper createNewLayer:self.mapView];
    self.signalLayer = [ArcGISHelper createNewLayer:self.mapView];

    self.locationLayer1 = [ArcGISHelper createNewLayer:self.mapView];
    self.locationLayer2 = [ArcGISHelper createNewLayer:self.mapView];
    self.hintLayer = [ArcGISHelper createNewLayer:self.mapView];
    
    self.locationSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"l7"];
    self.locationArrowSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"locationArrow2"];
    self.locationArrowSymbol.size = CGSizeMake(60, 60);

//    [self.mapView setLocationSymbol:self.locationSymbol];
    [self.mapView setLocationSymbol:self.locationArrowSymbol];
    
    NSString *title = [NSString stringWithFormat:@"%@调试", (self.name == nil ? @"" : self.name)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemTest:)];

    self.debugItems = [[NSMutableArray alloc] init];
    [self.debugItems addObject:[DebugItem itemWithID:IP_DEBUG_ITEM_PUBLIC_BEACON]];
    [self.debugItems addObject:[DebugItem itemWithID:IP_DEBUG_ITEM_BEACON_SIGNAL]];

    for (DebugItem *item in self.debugItems) {
        if (item.on) {
            [self performSelector:item.selector withObject:item afterDelay:0];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.publicBeaconRegion) {
        [self.locationManager startUpdateLocation];
        self.locationManager.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.publicBeaconRegion) {
        [self.locationManager stopUpdateLocation];
        self.locationManager.delegate = nil;
    }
}

- (void)initLocationSettings
{
    self.publicBeaconRegion = [TYRegionManager getBeaconRegionForBuilding:[TYUserDefaults getDefaultBuilding].buildingID].region;
    self.locationManager = [[TYLocationManager alloc] initWithBuilding:[TYUserDefaults getDefaultBuilding]];
    [self.locationManager setLimitBeaconNumber:YES];
    [self.locationManager setRssiThreshold:-90];
    self.locationManager.delegate = self;
    [self.locationManager setBeaconRegion:self.publicBeaconRegion];
}


- (IBAction)rightBarButtonItemTest:(id)sender
{
//    BRTLog(@"rightBarButtonItemTest");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"调试内容" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    for (DebugItem *item in self.debugItems) {
        [actionSheet addButtonWithTitle:(item.on ? item.nameOff : item.name)];
    }
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    BRTLog(@"clickedButtonAtIndex: %d", (int)buttonIndex);
    if (buttonIndex == 0) {
        return;
    }
    DebugItem *item = self.debugItems[buttonIndex - 1];
    [item switchStatus];
    [self performSelector:item.selector withObject:item afterDelay:0];
}

- (void)switchPublicBeacon:(id)sender
{
//    BRTLog(@"switchPublicBeacon");
    DebugItem *item = sender;
    if (item.on) {
        [LocationTestHelper showBeaconLocationsWithMapInfo:self.currentMapInfo Building:self.currentBuilding OnLayer:self.publicBeaconLayer];
    } else {
        [self.publicBeaconLayer removeAllGraphics];
    }
}

- (void)switchBeaconSignal:(id)sender
{
//    BRTLog(@"switchBeaconSignal");
    DebugItem *item = sender;
    self.isSignalOn = item.on;
}

- (void)tableViewFinished
{
    
}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
{
//    NSLog(@"didClickAtPoint: %f, %f", mappoint.x, mappoint.y);
//    NSLog(@"%f", self.mapView.mapScale);
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
