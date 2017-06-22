//
//  PDRTestVC.m
//  BLEProject
//
//  Created by innerpeacer on 2017/4/19.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "PDRTestVC.h"
#import "ArcGISHelper.h"
#import "TYMotionDetector.h"

#import <CoreLocation/CoreLocation.h>
#import "TYSimplePDRController.h"
#import "TYTrace.h"
//#import "TYTrace+Protobuf.h"
#import "PbfCollectionDatabase.h"
#import "TraceManager.h"
#import "TraceTableVC.h"
#import "TYLocationManager.h"

@interface PDRTestVC () <TYMotionDetectorDelegate, CLLocationManagerDelegate>
{
    TYMotionDetector *motionDetector;
    
    TYLocalPoint *currentLocation;
    
    CLLocationManager *systemLocationManager;
    
    TYSimplePDRController *pureController;
    TYSimplePDRController *pdrController;
    
    TYTrace *pureTrace;
    TYTrace *pdrTrace;
    BOOL isStarted;
}

@end

@implementation PDRTestVC

- (void)viewDidLoad {
    self.name = @"PDR";
    
    [super viewDidLoad];
    
    motionDetector = [[TYMotionDetector alloc] init];
    motionDetector.delegate = self;
    
    systemLocationManager = [[CLLocationManager alloc] init];
    systemLocationManager.delegate = self;
    [systemLocationManager startUpdatingHeading];
    
    pdrController = [[TYSimplePDRController alloc] initWithAngle:0];
    pureController = [[TYSimplePDRController alloc] initWithAngle:0];
        
    [self.debugItems addObject:[DebugItem itemWithID:IP_DEBUG_ITEM_START_TRACE]];
    [self.debugItems addObject:[DebugItem itemWithID:IP_DEBUG_ITEM_SAVE_TRACE]];
    [self.debugItems addObject:[DebugItem itemWithID:IP_DEBUG_ITEM_SHOW_TRACE]];
}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
{
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
//    BRTLog(@"LocationHeading: %f", newHeading.trueHeading);
//    arrowSymbol.angle = newHeading.trueHeading;
}

- (void)motionDetector:(TYMotionDetector *)detector onHeadingChanged:(double)heading
{
//    BRTLog(@"Heading: %f", heading);
    self.locationArrowSymbol.angle = heading;
    [pdrController updateHeading:heading];
    [pureController updateHeading:heading];
}

- (void)motionDetector:(TYMotionDetector *)detector onStepEvent:(TYStepEvent *)stepEvent
{
//    BRTLog(@"StepEvent");
    if (!isStarted) {
        return;
    }
    
    [pdrController addStepEvent];
    [pureController addStepEvent];
    
    TYLocalPoint *lp = pdrController.currentLocation;
    TYLocalPoint *pureLp = pureController.currentLocation;
    
    [ArcGISHelper drawLocalPoint:lp AtLayer:self.hintLayer WithSymbol:self.locationArrowSymbol ClearContent:YES];
    [ArcGISHelper drawLocalPoint:pureLp AtLayer:self.hintLayer WithSymbol:self.locationArrowSymbol ClearContent:NO];

    [pdrTrace addTracePointWithX:lp.x Y:lp.y Floor:lp.floor];
    [pureTrace addTracePointWithX:pureLp.x Y:pureLp.y Floor:pureLp.floor];

    [ArcGISHelper drawTrace:pdrTrace AtLayer:self.traceLayer1];
    [ArcGISHelper drawTrace:pureTrace AtLayer:self.traceLayer2 PointColor:[UIColor yellowColor] LineColor:[UIColor redColor] Width:@6];
}

- (void)TYLocationManager:(TYLocationManager *)manager didUpdateLocation:(TYLocalPoint *)newLocation
{
//    NSLog(@"%@", [newLocation description]);
    currentLocation = newLocation;
    
    [self.locationLayer1 removeAllGraphics];
    
    if (currentLocation.floor != self.mapView.currentMapInfo.floorNumber) {
        [self.mapView setFloorWithInfo:[TYMapInfo searchMapInfoFromArray:self.allMapInfos Floor:newLocation.floor]];
        self.title = self.mapView.currentMapInfo.floorName;
    }
    [self.mapView showLocation:currentLocation];
    
    if (!isStarted) {
        return;
    }
    
    if (pureController.currentLocation == nil) {
        [pureController setStartLocation:newLocation];
    }
    [pdrController setStartLocation:currentLocation];
    
//    [ArcGISHelper drawLocalPoint:currentLocation AtLayer:self.hintLayer WithSymbol:self.locationArrowSymbol ClearContent:YES];
//    [pdrTrace addTracePointWithX:newLocation.x Y:newLocation.y Floor:newLocation.floor];
}

- (void)showTrace:(id)sender
{
    BRTLog(@"showTrace");
    TraceTableNaviController *traceVC = [[TraceTableNaviController alloc] init];
    traceVC.startingController = self;
    [self presentViewController:traceVC animated:YES completion:^{
    }];
}

- (void)tableViewFinished
{
    TYTrace *trace = [TraceManager currentTrace];
    [ArcGISHelper drawTrace:trace AtLayer:self.traceLayer1 PointColor:nil LineColor:nil Width:nil];
}

- (void)saveTrace:(id)sender
{
    BRTLog(@"saveTrace: %@", pdrTrace);
    [TraceManager saveTrace:pdrTrace];
    [TraceManager saveTrace:pureTrace];
}

- (void)startTrace:(id)sender
{
    BRTLog(@"startTrace: %@", pdrTrace);
    pdrTrace = [TraceManager createNewTrace];
    pureTrace = [TraceManager createPureTrace];
    isStarted = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [motionDetector startHeadingDetector];
    [motionDetector startStepDetector];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [motionDetector stopAllDetectors];
}

@end
