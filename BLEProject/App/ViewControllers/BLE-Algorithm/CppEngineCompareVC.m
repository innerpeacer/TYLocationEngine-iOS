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
    AGSGraphicsLayer *hintLayer;
    AGSGraphicsLayer *np2ResultLayer;
    AGSGraphicsLayer *npResultLayer;
    AGSGraphicsLayer *publicBeaconLayer;
    
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
    if (publicBeaconRegion) {
        [np2LocationManager startUpdateLocation];
        [npLocationManager startUpdateLocation];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (publicBeaconRegion) {
        [np2LocationManager stopUpdateLocation];
        [npLocationManager stopUpdateLocation];
    }

}


- (void)addLayers
{
    hintLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:hintLayer];
    
    publicBeaconLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:publicBeaconLayer];
    
    np2ResultLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:np2ResultLayer];
    
    npResultLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:npResultLayer];
}

- (void)initLocationSettings
{
    publicBeaconRegion = [TYRegionManager getBeaconRegionForBuilding:[TYUserDefaults getDefaultBuilding].buildingID].region;
    
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

- (void)TYLocationManager:(TYLocationManager *)manager didUpdateImmediateLocation:(TYLocalPoint *)newImmediateLocation
{
    
}

- (void)TYLocationManager:(TYLocationManager *)manager didUpdateDeviceHeading:(double)newHeading
{
    
}

- (void)TYLocationManagerdidFailUpdateLocation:(TYLocationManager *)manager
{

}

//- (void)TYLocationManager:(TYLocationManager *)manager didRangedBeacons:(NSArray *)beacons
//{
//    NSLog(@"TYLocationManager:didRangedBeacons: %d", (int)beacons.count);
//    for (TYBeacon *b in beacons) {
//        NSLog(@"%@", b);
//    }
//}
//
//- (void)TYLocationManager:(TYLocationManager *)manager didRangedLocationBeacons:(NSArray *)beacons
//{
//    NSLog(@"TYLocationManager:didRangedLocationBeacons: %d", (int)beacons.count);
//    for (TYPublicBeacon *b in beacons) {
//        NSLog(@"%@", b);
//    }
//}

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
