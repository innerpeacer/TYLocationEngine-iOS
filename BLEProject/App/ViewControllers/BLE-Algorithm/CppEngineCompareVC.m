//
//  CppEngineCompareVC.m
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "CppEngineCompareVC.h"
#import "TYBeaconFMDBAdapter.h"
#import <TYMapSDK/TYMapSDK.h>


#import "TYRegionManager.h"
#import "TYLocationManager.h"
#import "TYUserDefaults.h"

@interface CppEngineCompareVC() <TYLocationManagerDelegate>
{
    TYGraphicsLayer *hintLayer;
    TYGraphicsLayer *np2ResultLayer;
    TYGraphicsLayer *npResultLayer;
    TYGraphicsLayer *publicBeaconLayer;
    
    CLBeaconRegion *publicBeaconRegion;
    
    TYLocationManager *np2LocationManager;
    TYLocationManager *npLocationManager;
}

@property (weak, nonatomic) IBOutlet UISwitch *publicSwitch;

- (IBAction)publicSwitchToggled:(id)sender;

@end

@implementation CppEngineCompareVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLayers];
    [self initLocationSettings];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [np2LocationManager startUpdateLocation];
    [npLocationManager startUpdateLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [np2LocationManager stopUpdateLocation];
    [npLocationManager stopUpdateLocation];
}


- (void)addLayers
{
    hintLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:hintLayer];
    
    publicBeaconLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:publicBeaconLayer];
    
    np2ResultLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:np2ResultLayer];
    
    npResultLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:npResultLayer];
}

- (void)initLocationSettings
{
    publicBeaconRegion = [TYRegionManager getBeaconRegionForBuilding:[TYUserDefaults getDefaultBuilding].buildingID];
    
    np2LocationManager = [[TYLocationManager alloc] initWithBuilding:self.currentBuilding];
    np2LocationManager.delegate = self;
    [np2LocationManager setBeaconRegion:publicBeaconRegion];
    [np2LocationManager startUpdateLocation];
    
    npLocationManager = [[TYLocationManager alloc] initWithBuilding:self.currentBuilding];
    npLocationManager.delegate = self;
    [npLocationManager setBeaconRegion:publicBeaconRegion];
    [npLocationManager startUpdateLocation];
    
}

- (void)TYLocationManager:(TYLocationManager *)manager didUpdateLocation:(TYLocalPoint *)newLocation
{
    [npResultLayer removeAllGraphics];
    
    AGSPoint *pos = [AGSPoint pointWithX:newLocation.x y:newLocation.y spatialReference:self.mapView.spatialReference];
    AGSGeometryEngine *engine = [[AGSGeometryEngine alloc] init];
    
    AGSPolygon *buf2m = [engine bufferGeometry:pos byDistance:2.0];
    AGSSimpleFillSymbol *sfs2m = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5] outlineColor:[UIColor blackColor]];
    [npResultLayer addGraphic:[AGSGraphic graphicWithGeometry:buf2m symbol:sfs2m attributes:nil]];
    
    AGSPolygon *buf3m = [engine bufferGeometry:pos byDistance:3.0];
    AGSSimpleFillSymbol *sfs3m = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5] outlineColor:[UIColor blackColor]];
    [npResultLayer addGraphic:[AGSGraphic graphicWithGeometry:buf3m symbol:sfs3m attributes:nil]];
    
    AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor blueColor]];
    sms.size = CGSizeMake(6, 6);
    sms.style = AGSSimpleMarkerSymbolStyleCircle;
    [npResultLayer addGraphic:[AGSGraphic graphicWithGeometry:pos symbol:sms attributes:nil]];
}

- (void)TYLocationManager:(TYLocationManager *)manager didUpdateDeviceHeading:(double)newHeading
{
    
}

- (void)TYLocationManagerdidFailUpdateLocation:(TYLocationManager *)manager
{

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
            
            AGSTextSymbol *ts = [AGSTextSymbol textSymbolWithText:[NSString stringWithFormat:@"%@\n%@", pb.minor, pb.tag] color:[UIColor magentaColor]];
            [ts setOffset:CGPointMake(5, -20)];
            [publicBeaconLayer addGraphic:[AGSGraphic graphicWithGeometry:p symbol:ts attributes:nil]];
            
        }
        [pdb close];
    } else {
        [publicBeaconLayer removeAllGraphics];
    }
}

@end
