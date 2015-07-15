//
//  CAMultiLocationTestVC.m
//  BLEProject
//
//  Created by innerpeacer on 15/1/29.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "MultiLocationTestVC.h"
#import "NPLocationEngine.h"
#import "NPGeometryFactory.h"

@interface MultiLocationTestVC()
{
    NPLocationEngine *quadraticLocationEngine;
    NPLocationEngine *linearLocationEngine;
}

@end

@implementation MultiLocationTestVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    quadraticLocationEngine = [NPLocationEngine locationEngineWithBeacons:self.allBeacons Type:QuadraticWeighting];
    linearLocationEngine = [NPLocationEngine locationEngineWithBeacons:self.allBeacons Type:LinearWeighting];
}

- (void)showHintRssiForBeacons:(NSArray *)beacons
{

}

- (void)onStepEvent:(NPStepEvent *)stepEvent
{
    NSLog(@"onStepEvent");
    
    [quadraticLocationEngine addStepEvent:stepEvent];
    [linearLocationEngine addStepEvent:stepEvent];
}

- (void)processLocationResult
{
    [self.resultLayer removeAllGraphics];
    
    [self showSimpleResultForLocationEngine:quadraticLocationEngine withColor:[UIColor greenColor] Size:CGSizeMake(5, 5)];    
}

- (void)showSimpleResultForLocationEngine:(NPLocationEngine *)engine withColor:(UIColor *)color  Size:(CGSize)size
{
    [engine processBeacons:self.scannedBeacons];
    TYLocalPoint *location = [engine getLocation];
    
    if (location != nil) {
        TYPoint *pos = [TYPoint pointWithX:location.x y:location.y spatialReference:self.mapView.spatialReference];
        [TYArcGISDrawer drawPoint:pos AtLayer:self.resultLayer WithColor:color Size:CGSizeMake(5, 5)];
    }

}

- (void)showBufferedResultForLocationEngine:(NPLocationEngine *)engine Size:(CGSize)size
{
    [engine processBeacons:self.scannedBeacons];
    TYLocalPoint *location = [engine getLocation];
    TYLocalPoint *directLocation = [engine getDirectioLocation];
    
    if (location != nil) {
        TYPoint *pos = [TYPoint pointWithX:location.x y:location.y spatialReference:self.mapView.spatialReference];
        [TYArcGISDrawer drawPoint:pos AtLayer:self.resultLayer WithBuffer1:2.0 Buffer2:3.0];

        TYPoint *directPos = [TYPoint pointWithX:directLocation.x y:directLocation.y spatialReference:self.mapView.spatialReference];
        [TYArcGISDrawer drawPoint:directPos AtLayer:self.resultLayer WithColor:[UIColor greenColor] Size:size];

    }
}

@end
