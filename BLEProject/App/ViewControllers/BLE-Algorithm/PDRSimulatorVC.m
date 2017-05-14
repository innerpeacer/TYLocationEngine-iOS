//
//  PDRSimulatorVC.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/11.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "PDRSimulatorVC.h"
#import "TYRawDataManager.h"
#import "TYPDRSimulator.h"
#import "ArcGISHelper.h"
#import "TYSimplePDRController.h"

@interface PDRSimulatorVC () <TYPDRSimulatorDelegate>
{
    TYRawDataCollection *collection;
    TYPDRSimulator *simulator;
    
    TYSimplePDRController *pdrController;
    TYSimplePDRController *pdrUpdatingController;
    
    double currentHeading;
    
    BOOL isPaused;
}
@end

@implementation PDRSimulatorVC

- (void)viewDidLoad {
    [super viewDidLoad];

    collection = [TYRawDataManager getData:self.dataID];
    simulator = [[TYPDRSimulator alloc] initWithData:collection];
    simulator.delegate = self;
    
    [self initMapSettings];
    
    
    pdrController = [[TYSimplePDRController alloc] initWithAngle:0];
    pdrUpdatingController = [[TYSimplePDRController alloc] initWithAngle:0];
    
    [simulator setReplaySpeed:3.0];
//    [simulator start];
    
    
    [self.debugItems addObject:[DebugItem itemWithID:IP_DEBUG_ITEM_START_REPLAY]];
    for (DebugItem *item in self.debugItems) {
        if (item.on) {
            [self performSelector:item.selector withObject:item afterDelay:0];
        }
    }
}

- (IBAction)startReplay:(id)sender
{
    DebugItem *item = sender;
    if (item.on) {
        [simulator start];
    } else {
        [simulator cancel];
    }
}

- (void)initMapSettings
{
    self.locationReplayLayer = [TYReplayTraceLayer newLayer:self.mapView];
//    self.locationReplayLayer.markSymbol = [self.locationArrowSymbol copy];
//    self.locationReplayLayer.markSymbol = nil;
    
    self.stepReplayLayer = [TYReplayTraceLayer newLayer:self.mapView];
    self.stepReplayLayer.lineSymbol.color = [UIColor yellowColor];
}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
{
    isPaused = !isPaused;
    
    if (isPaused) {
        [simulator pause];
    } else {
        [simulator resume];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [simulator cancel];
}

- (void)simulator:(id)sender replaySignal:(TYRawSignalEvent *)signal
{
//    BRTLog(@"replaySignal");
    TYLocalPoint *newLocation = [signal.location toLocalPoint];
    [self.mapView showLocation:newLocation];
    
    [self.locationReplayLayer addTracePoint:newLocation Angle:currentHeading];
    
    if (pdrController.currentLocation == nil) {
        [pdrController setStartLocation:newLocation];
    }
    
    [LocationTestHelper showHintRssiForLocationBeacons:[signal toPublicBeaconArray] WithMapInfo:self.currentMapInfo OnLayer:self.signalLayer];
}

- (void)simulator:(id)sender replayStep:(TYRawStepEvent *)step
{
//    BRTLog(@"replayStep");
    [pdrController addStepEvent];
    [self.stepReplayLayer addTracePoint:pdrController.currentLocation Angle:currentHeading];
}

- (void)simulator:(id)sender replayHeading:(TYRawHeadingEvent *)heading
{
//    BRTLog(@"replayHeading");
    currentHeading = heading.heading;
    
    [pdrController updateHeading:currentHeading];
    [self.mapView processDeviceRotation:heading.heading];
}

- (void)simulatorDidStart:(id)sender
{
    BRTLog(@"simulatorDidStart:");
    pdrController.currentLocation = nil;
}

- (void)simulatorDidFinish:(id)sender
{
    BRTLog(@"simulatorDidFinish");
}

- (void)simulatorDidPause:(TYPDRSimulator *)simulator
{
    BRTLog(@"simulatorDidPause");
}

- (void)simulatorDidResume:(TYPDRSimulator *)simulator
{
    BRTLog(@"simulatorDidResume");
}

- (void)simulatorDidCancel:(TYPDRSimulator *)simulator
{
    BRTLog(@"simulatorDidCancel");
    [self.stepReplayLayer reset];
    [self.locationReplayLayer reset];
}

@end
