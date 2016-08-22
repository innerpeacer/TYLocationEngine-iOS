//
//  ConfigurePointPositionVC.m
//  BLEProject
//
//  Created by innerpeacer on 15/12/1.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "ConfigurePointPositionVC.h"

#import <TYMapSDK/TYMapSDK.h>

#import "TYUserDefaults.h"
#import "TYBeaconFMDBAdapter.h"
#import "TYBeacon.h"
#import "TYBeaconManager.h"

#import "TYRegionManager.h"
#import "IPBeaconDBCodeChecker.h"
#import "TYPointPosFMDBAdapter.h"

#define BUFFER_LENGTH 5.0

@interface ConfigurePointPositionVC()
{
    AGSGraphicsLayer *hintLayer;
    AGSGraphicsLayer *pointPositionLayer;
    
    TYLocalPoint *currentLocation;
    
    int currentMax;
    
    BOOL isEditing;
}
@property (weak, nonatomic) IBOutlet UISwitch *publicSwitch;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UIButton *bindingButton;

- (IBAction)addCurrentBeacon:(id)sender;
- (IBAction)publicSwtichToggled:(id)sender;

@end

@implementation ConfigurePointPositionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.mapView.highlightPOIOnSelection = YES;
    [self addLayers];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"点位列表" style:UIBarButtonItemStylePlain target:self action:@selector(showConfiguredPointPosition:)];
}



- (void)addLayers
{
    hintLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:hintLayer];
    
    pointPositionLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:pointPositionLayer];
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
    
//    [self addCurrentBeacon:nil];
    if (isEditing) {
        [self addCurrentBeaconPosition];
        [self addCurrentBeacon:nil];
    }
}

- (void)addCurrentBeaconPosition
{
    if (currentLocation) {
        TYPointPosFMDBAdapter *db = [[TYPointPosFMDBAdapter alloc] initWithBuilding:self.currentBuilding];
        [db open];
        int maxTag = [db getMaxIndex];
        NSLog(@"Max Tag: %d", maxTag);
        
        TYPointPosition *pointPos = [[TYPointPosition alloc] init];
        pointPos.location = currentLocation;
        pointPos.posIndex = maxTag + 1;
        [db insertPointPosition:pointPos];
        [db close];
        
        self.hintLabel.text = @"";
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Location or Beacon is nil" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)addCurrentBeacon:(id)sender {
//    if (currentLocation) {
//        TYPointPosFMDBAdapter *db = [[TYPointPosFMDBAdapter alloc] initWithBuilding:self.currentBuilding];
//        [db open];
//        int maxTag = [db getMaxTag];
//        NSLog(@"Max Tag: %d", maxTag);
//        
//        TYPointPosition *pointPos = [[TYPointPosition alloc] init];
//        pointPos.location = currentLocation;
//        pointPos.tag = maxTag + 1;
//        [db insertPointPosition:pointPos];
//        [db close];
//        
//        self.hintLabel.text = @"";
//    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Location or Beacon is nil" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
    

    [pointPositionLayer removeAllGraphics];
    TYPointPosFMDBAdapter *db = [[TYPointPosFMDBAdapter alloc] initWithBuilding:self.currentBuilding];
    [db open];
    
    AGSSimpleFillSymbol *sfs = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:0 green:0.1 blue:0 alpha:0.2] outlineColor:[UIColor colorWithRed:0 green:0.1 blue:0 alpha:1.0]];
    
    NSArray *array = [db getAllPointPositions];
    for (TYPointPosition *pp in array) {
        if (pp.location.floor != self.currentMapInfo.floorNumber && pp.location.floor != 0) {
            continue;
        }
        AGSPoint *p = [AGSPoint pointWithX:pp.location.x y:pp.location.y spatialReference:self.mapView.spatialReference];
        AGSPolygon *pbuffer = [[AGSGeometryEngine defaultGeometryEngine] bufferGeometry:p byDistance:BUFFER_LENGTH];
        
        [pointPositionLayer addGraphic:[AGSGraphic graphicWithGeometry:pbuffer symbol:sfs attributes:nil]];
        [TYArcGISDrawer drawPoint:p AtLayer:pointPositionLayer WithColor:[UIColor redColor]];
        AGSTextSymbol *ts = [AGSTextSymbol textSymbolWithText:[NSString stringWithFormat:@"%d", pp.posIndex] color:[UIColor magentaColor]];
        [ts setOffset:CGPointMake(5, -10)];
        [pointPositionLayer addGraphic:[AGSGraphic graphicWithGeometry:p symbol:ts attributes:nil]];
    }
    [db close];

}

- (IBAction)publicSwtichToggled:(id)sender {
//    if (self.publicSwitch.on) {
//        TYPointPosFMDBAdapter *db = [[TYPointPosFMDBAdapter alloc] initWithBuilding:self.currentBuilding];
//        [db open];
//        NSArray *array = [db getAllPointPositions];
//        for (TYPointPosition *pp in array) {
//            if (pp.location.floor != self.currentMapInfo.floorNumber && pp.location.floor != 0) {
//                continue;
//            }
//            AGSPoint *p = [AGSPoint pointWithX:pp.location.x y:pp.location.y spatialReference:self.mapView.spatialReference];
//            [TYArcGISDrawer drawPoint:p AtLayer:pointPositionLayer WithColor:[UIColor redColor]];
//            AGSTextSymbol *ts = [AGSTextSymbol textSymbolWithText:[NSString stringWithFormat:@"%d", pp.tag] color:[UIColor magentaColor]];
//            [ts setOffset:CGPointMake(5, -10)];
//            [pointPositionLayer addGraphic:[AGSGraphic graphicWithGeometry:p symbol:ts attributes:nil]];
//        }
//        [db close];
//        
//    } else {
//        [pointPositionLayer removeAllGraphics];
//    }
    isEditing = self.publicSwitch.on;
}

- (IBAction)showConfiguredPointPosition:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BLE-Tool" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ShowPointPositionRootController"];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
