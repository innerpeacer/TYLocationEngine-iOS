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
#import "TYBuildingMonitor.h"

@interface CppEngineTestVC () <TYLocationManagerDelegate>
{
    TYGraphicsLayer *hintLayer;
    TYGraphicsLayer *resultLayer;
    TYGraphicsLayer *publicBeaconLayer;
    
    CLBeaconRegion *publicBeaconRegion;

    TYLocationManager *locationManager;
    
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
    
    pms = [TYPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"l7"];
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
//    publicBeaconRegion = [TYRegionManager defaultRegion];
    publicBeaconRegion = [TYRegionManager getBeaconRegionForBuilding:[TYUserDefaults getDefaultBuilding].buildingID];

    locationManager = [[TYLocationManager alloc] initWithBuilding:[TYUserDefaults getDefaultBuilding]];

    
    [locationManager setLimitBeaconNumber:YES];
//    [locationManager setLimitBeaconNumber:NO];
    [locationManager setRssiThreshold:-90];
    
    locationManager.delegate = self;
    [locationManager setBeaconRegion:publicBeaconRegion];
    [locationManager startUpdateLocation];

}

- (void)TYLocationManager:(TYLocationManager *)manager didUpdateLocation:(TYLocalPoint *)newLocation
{
    [resultLayer removeAllGraphics];
    
    if (newLocation.floor != self.mapView.currentMapInfo.floorNumber) {
        [self.mapView setFloorWithInfo:[TYMapInfo searchMapInfoFromArray:self.allMapInfos Floor:newLocation.floor]];
        self.title = self.mapView.currentMapInfo.floorName;
    }
    
    
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
            
            TYPoint *p = [TYPoint pointWithX:pb.location.x y:pb.location.y spatialReference:self.mapView.spatialReference];
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

@end
