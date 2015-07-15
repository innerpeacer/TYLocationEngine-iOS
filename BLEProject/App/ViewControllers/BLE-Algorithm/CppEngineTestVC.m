//
//  CppEngineTestVC.m
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "CppEngineTestVC.h"
#import "NPBeaconFMDBAdapter.h"

#import <TYMapSDK/TYMapSDK.h>

#import "NPLocationManager.h"
#import "TYRegionManager.h"
#import "TYUserDefaults.h"
#import "AppConstants.h"

#import "NPBuildingMonitor.h"

@interface CppEngineTestVC () <NPLocationManagerDelegate>
{
    TYGraphicsLayer *hintLayer;
    TYGraphicsLayer *resultLayer;
    TYGraphicsLayer *publicBeaconLayer;
    
    CLBeaconRegion *publicBeaconRegion;

    NPLocationManager *locationManager;
    
    TYPictureMarkerSymbol *pms;
    TYPathCalibration *pathCalibration;
    
    
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
    
    pathCalibration = [[TYPathCalibration alloc] initWithFloorID:@"002100002F20"];
    
    pms = [TYPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"locationArrow"];
    [self.mapView setLocationSymbol:(TYMarkerSymbol *)pms];
    
    [self.mapView setMapMode:TYMapViewModeDefault];
//    [self.mapView setMapMode:TYMapViewModeFollowing];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [locationManager startUpdateLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [locationManager stopUpdateLocation];
}


- (void)addLayers
{
    hintLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:hintLayer];
        
    publicBeaconLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:publicBeaconLayer];
    
    resultLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:resultLayer];
}

- (void)initLocationSettings
{
    publicBeaconRegion = [TYRegionManager defaultRegion];
    locationManager = [[NPLocationManager alloc] initWithBuilding:[TYUserDefaults getDefaultBuilding]];

    
    [locationManager setLimitBeaconNumber:YES];
//    [locationManager setLimitBeaconNumber:NO];
    [locationManager setRssiThreshold:-90];
    
    locationManager.delegate = self;
    [locationManager setBeaconRegion:publicBeaconRegion];
    [locationManager startUpdateLocation];

}

- (void)NPLocationManager:(NPLocationManager *)manager didUpdateLocation:(TYLocalPoint *)newLocation
{
    [resultLayer removeAllGraphics];
    
    TYPoint *pos = [TYPoint pointWithX:newLocation.x y:newLocation.y spatialReference:self.mapView.spatialReference];
    
    [self.mapView showLocation:newLocation];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
#define PADDING 30
    CGRect restrictRange = CGRectMake(screenBound.origin.x + PADDING, screenBound.origin.y + PADDING, screenBound.size.width - PADDING * 2, screenBound.size.height - PADDING * 2);
    
    [self.mapView restrictLocation:pos toScreenRange:restrictRange];

}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(TYPoint *)mappoint
{
    NSLog(@"didClickAtPoint: %f, %f", mappoint.x, mappoint.y);
}

- (void)NPLocationManager:(NPLocationManager *)manager didUpdateDeviceHeading:(double)newHeading
{
    [self.mapView processDeviceRotation:newHeading];
}

- (void)NPLocationManagerdidFailUpdateLocation:(NPLocationManager *)manager
{
    NSLog(@"NPLocationManagerdidFailUpdateLocation");
    [self.mapView removeLocation];
}

- (IBAction)publicSwitchToggled:(id)sender {
    if (self.publicSwitch.on) {
        
        NPBeaconFMDBAdapter *pdb = [[NPBeaconFMDBAdapter alloc] initWithBuilding:self.currentBuilding];
        [pdb open];
        
        NSArray *array = [pdb getAllNephogramBeacons];
        for (NPPublicBeacon *pb in array)
        {
            if (pb.location.floor != self.currentMapInfo.floorNumber && pb.location.floor != 0) {
                continue;
            }
            
            TYPoint *p = [TYPoint pointWithX:pb.location.x y:pb.location.y spatialReference:self.mapView.spatialReference];
            [TYArcGISDrawer drawPoint:p AtLayer:publicBeaconLayer WithColor:[UIColor redColor]];
            
            
            AGSTextSymbol *ts = [AGSTextSymbol textSymbolWithText:[NSString stringWithFormat:@"%@\n%@", pb.minor, pb.tag] color:[UIColor magentaColor]];
            [ts setOffset:CGPointMake(5, -20)];
            [publicBeaconLayer addGraphic:[AGSGraphic graphicWithGeometry:p symbol:ts attributes:nil]];
            
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

@end
