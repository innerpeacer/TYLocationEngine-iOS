//
//  CppEngineTestVC.m
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "CppEngineTestVC.h"
#import "TYBeaconFMDBAdapter.h"

#import <TYMapSDK/TYMapSDK.h>

#import "TYLocationManager.h"
#import "TYRegionManager.h"
#import "TYUserDefaults.h"

@interface CppEngineTestVC () <TYLocationManagerDelegate>
{
    AGSGraphicsLayer *hintLayer;
    AGSGraphicsLayer *resultLayer;
    AGSGraphicsLayer *immediateLayer;
    AGSGraphicsLayer *publicBeaconLayer;
    
    CLBeaconRegion *publicBeaconRegion;

    TYLocationManager *locationManager;
    
    AGSPictureMarkerSymbol *pms;
}

@property (weak, nonatomic) IBOutlet UISwitch *publicSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *followingModeSwitch;

- (IBAction)publicSwitchToggled:(id)sender;
- (IBAction)followingModeSwitchToggled:(id)sender;

@end

@implementation CppEngineTestVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addLayers];
    [self initLocationSettings];
    
//    pathCalibration = [[TYPathCalibration alloc] initWithFloorID:@"002100002F20"];
    
    pms = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"l7"];
    [self.mapView setLocationSymbol:pms];
    
    [self.mapView setMapMode:TYMapViewModeDefault];
//    [self.mapView setMapMode:TYMapViewModeFollowing];
    
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


- (void)addLayers
{
    hintLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:hintLayer];
        
    publicBeaconLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:publicBeaconLayer];
    
    resultLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:resultLayer];
    
    immediateLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:immediateLayer];
}

- (void)initLocationSettings
{
    publicBeaconRegion = [TYRegionManager getBeaconRegionForBuilding:[TYUserDefaults getDefaultBuilding].buildingID].region;
    locationManager = [[TYLocationManager alloc] initWithBuilding:[TYUserDefaults getDefaultBuilding]];
    [locationManager setLimitBeaconNumber:YES];
//    [locationManager setLimitBeaconNumber:NO];
    [locationManager setRssiThreshold:-90];
        locationManager.delegate = self;
    [locationManager setBeaconRegion:publicBeaconRegion];
//    [locationManager startUpdateLocation];

}

- (void)TYLocationManager:(TYLocationManager *)manager didUpdateLocation:(TYLocalPoint *)newLocation
{
//    [resultLayer removeAllGraphics];
//    
//    if (newLocation.floor != self.mapView.currentMapInfo.floorNumber) {
//        [self.mapView setFloorWithInfo:[TYMapInfo searchMapInfoFromArray:self.allMapInfos Floor:newLocation.floor]];
//        self.title = self.mapView.currentMapInfo.floorName;
//    }
//    
//    AGSPoint *pos = [AGSPoint pointWithX:newLocation.x y:newLocation.y spatialReference:self.mapView.spatialReference];
//    [self.mapView showLocation:newLocation];
//    
//    CGRect screenBound = [[UIScreen mainScreen] bounds];
//#define PADDING 30
//    CGRect restrictRange = CGRectMake(screenBound.origin.x + PADDING, screenBound.origin.y + PADDING, screenBound.size.width - PADDING * 2, screenBound.size.height - PADDING * 2);
//    
//    [self.mapView restrictLocation:pos toScreenRange:restrictRange];
}

- (void)TYLocationManager:(TYLocationManager *)manager didUpdateImmediateLocation:(TYLocalPoint *)newImmediateLocation
{
//    [immediateLayer removeAllGraphics];
//    
//    AGSPoint *pos = [AGSPoint pointWithX:newImmediateLocation.x y:newImmediateLocation.y spatialReference:self.mapView.spatialReference];
//    AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor greenColor]];
//    sms.size = CGSizeMake(8, 8);
//    [immediateLayer addGraphic:[AGSGraphic graphicWithGeometry:pos symbol:sms attributes:nil]];
    
    [resultLayer removeAllGraphics];
    
    if (newImmediateLocation.floor != self.mapView.currentMapInfo.floorNumber) {
        [self.mapView setFloorWithInfo:[TYMapInfo searchMapInfoFromArray:self.allMapInfos Floor:newImmediateLocation.floor]];
        self.title = self.mapView.currentMapInfo.floorName;
    }
    
    AGSPoint *pos = [AGSPoint pointWithX:newImmediateLocation.x y:newImmediateLocation.y spatialReference:self.mapView.spatialReference];
    [self.mapView showLocation:newImmediateLocation];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
#define PADDING 30
    CGRect restrictRange = CGRectMake(screenBound.origin.x + PADDING, screenBound.origin.y + PADDING, screenBound.size.width - PADDING * 2, screenBound.size.height - PADDING * 2);
    
    [self.mapView restrictLocation:pos toScreenRange:restrictRange];
    
    [self.mapView centerAtPoint:pos animated:YES];
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
//    NSLog(@"TYLocationManagerdidFailUpdateLocation");
    [self.mapView removeLocation];
}

- (void)TYLocationManager:(TYLocationManager *)manager didRangedBeacons:(NSArray *)beacons
{
//    NSLog(@"TYLocationManager:didRangedBeacons: %d", (int)beacons.count);
//    for (TYBeacon *b in beacons) {
//        NSLog(@"%@", b);
//    }
}

- (void)TYLocationManager:(TYLocationManager *)manager didRangedLocationBeacons:(NSArray *)beacons
{
    NSLog(@"TYLocationManager:didRangedLocationBeacons: %d", (int)beacons.count);
    for (TYPublicBeacon *b in beacons) {
        NSLog(@"%@", b);
    }
    [self showHintRssiForLocationBeacons:beacons];
}

- (IBAction)publicSwitchToggled:(id)sender {
    if (self.publicSwitch.on) {
        TYBeaconFMDBAdapter *pdb = [[TYBeaconFMDBAdapter alloc] initWithBuilding:self.currentBuilding];
        [pdb open];
        NSArray *array = [pdb getAllLocationingBeacons];
        for (TYPublicBeacon *pb in array)
        {
            if (pb.location.floor != self.currentMapInfo.floorNumber && pb.location.floor != 0) {
                continue;
            }
            
            AGSPoint *p = [AGSPoint pointWithX:pb.location.x y:pb.location.y spatialReference:self.mapView.spatialReference];
            [TYArcGISDrawer drawPoint:p AtLayer:publicBeaconLayer WithColor:[UIColor redColor]];
            
//            AGSTextSymbol *ts = [AGSTextSymbol textSymbolWithText:[NSString stringWithFormat:@"%@\n%@", pb.minor, pb.tag] color:[UIColor magentaColor]];
//            [ts setOffset:CGPointMake(5, -20)];
//            [publicBeaconLayer addGraphic:[AGSGraphic graphicWithGeometry:p symbol:ts attributes:nil]];
            AGSTextSymbol *minorTs = [AGSTextSymbol textSymbolWithText:[NSString stringWithFormat:@"%@", pb.minor] color:[UIColor magentaColor]];
            [minorTs setOffset:CGPointMake(5, -12)];
            [publicBeaconLayer addGraphic:[AGSGraphic graphicWithGeometry:p symbol:minorTs attributes:nil]];
            
            AGSTextSymbol *tagTs = [AGSTextSymbol textSymbolWithText:[NSString stringWithFormat:@"%@", pb.tag] color:[UIColor magentaColor]];
            [tagTs setOffset:CGPointMake(5, -24)];
            [publicBeaconLayer addGraphic:[AGSGraphic graphicWithGeometry:p symbol:tagTs attributes:nil]];
            
        }
        [pdb close];
    } else {
        [publicBeaconLayer removeAllGraphics];
    }
}

- (IBAction)followingModeSwitchToggled:(id)sender {
    if (self.followingModeSwitch.on) {
        [self.mapView setMapMode:TYMapViewModeFollowing];
    } else {
        [self.mapView setMapMode:TYMapViewModeDefault];
    }
}

- (void)showHintRssiForLocationBeacons:(NSArray *)beacons
{
    [hintLayer removeAllGraphics];
    
    for (TYPublicBeacon *pb in beacons) {
        if (pb.location.floor == self.currentMapInfo.floorNumber) {
            NSString *rssi = [NSString stringWithFormat:@"%.2f, %d", pb.accuracy,(int) pb.rssi];
            AGSTextSymbol *ts = [AGSTextSymbol textSymbolWithText:rssi color:[UIColor blueColor]];
            [ts setOffset:CGPointMake(5, 10)];
            AGSPoint *pos = [AGSPoint pointWithX:pb.location.x y:pb.location.y spatialReference:self.mapView.spatialReference];
            AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:pos symbol:ts attributes:nil];
            [hintLayer addGraphic:graphic];
            
            AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor redColor]];
            sms.size = CGSizeMake(5, 5);
            [hintLayer addGraphic:[AGSGraphic graphicWithGeometry:pos symbol:sms attributes:nil]];
        }
    }
    
    
}



@end
