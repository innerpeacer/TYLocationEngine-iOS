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
#import "TYFusionPDRController.h"

@interface PDRSimulatorVC () <TYPDRSimulatorDelegate>
{
    TYRawDataCollection *collection;
    TYPDRSimulator *simulator;
    
    TYSimplePDRController *pdrController;
    TYSimplePDRController *pdrUpdatingController;
    TYFusionPDRController *pdrFusionController;
    
    double currentHeading;
    
    BOOL isPaused;
}
@end

@implementation PDRSimulatorVC

- (void)viewDidLoad {
    [super viewDidLoad];

    BRTLog(@"%@", self.dataID);
    collection = [TYRawDataManager getData:self.dataID];
    simulator = [[TYPDRSimulator alloc] initWithData:collection];
    simulator.delegate = self;
    
    [self initMapSettings];
    self.mapView.allowRotationByPinching = NO;
    [self.mapView zoomToEnvelope:[AGSEnvelope envelopeWithXmin:13523497.578848 ymin:3642439.640312 xmax:13523524.595785 ymax:3642484.472765 spatialReference:self.mapView.spatialReference] animated:NO];
    
    pdrController = [[TYSimplePDRController alloc] initWithAngle:0];
    pdrUpdatingController = [[TYSimplePDRController alloc] initWithAngle:0];
    pdrFusionController = [[TYFusionPDRController alloc] initWithAngle:0];
    [simulator setReplaySpeed:10.0];
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
//    self.locationReplayLayer.visible = NO;
    
    self.stepReplayLayer = [TYReplayTraceLayer newLayer:self.mapView];
    self.stepReplayLayer.lineSymbol.color = [UIColor yellowColor];
//    self.stepReplayLayer.visible = NO;
    
    self.updateingStepReplayLayer = [TYReplayTraceLayer newLayer:self.mapView];
    self.updateingStepReplayLayer.lineSymbol.color = [UIColor blueColor];
//    self.updateingStepReplayLayer.visible = NO;
    
    self.fusionStepReplayLayer = [TYReplayTraceLayer newLayer:self.mapView];
    self.fusionStepReplayLayer.lineSymbol.color = [UIColor magentaColor];
//    self.fusionStepReplayLayer.visible = NO;
}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
{
    BRTLog(@"%@", self.mapView.visibleAreaEnvelope);
    isPaused = !isPaused;
    
//    if (isPaused) {
//        [simulator pause];
//    } else {
//        [simulator resume];
//    }
    
    if (isPaused) {
        [simulator cancel];
    } else {
        [simulator start];
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
        BRTLog(@"Set Start: %@", newLocation);
        [pdrController setStartLocation:newLocation];
    }
    [pdrUpdatingController setStartLocation:newLocation];
    
    if (pdrFusionController.currentLocation == nil) {
        [pdrFusionController setStartLocation:newLocation];
    } else {
        [pdrFusionController updateRawSignalEvent:signal];
    }
    
    [LocationTestHelper showHintRssiForLocationBeacons:[signal toPublicBeaconArray] WithMapInfo:self.currentMapInfo OnLayer:self.signalLayer];
}

- (void)simulator:(id)sender replayStep:(TYRawStepEvent *)step
{
//    BRTLog(@"replayStep");
    [pdrController addStepEvent];
    [pdrUpdatingController addStepEvent];
    [pdrFusionController addStepEvent];
    
//    BRTLog(@"%@", pdrController.currentLocation);
    [self.stepReplayLayer addTracePoint:pdrController.currentLocation Angle:currentHeading];
    [self.updateingStepReplayLayer addTracePoint:pdrUpdatingController.currentLocation Angle:currentHeading];
    [self.fusionStepReplayLayer addTracePoint:pdrFusionController.currentLocation Angle:currentHeading];
}

- (void)simulator:(id)sender replayHeading:(TYRawHeadingEvent *)heading
{
//    BRTLog(@"replayHeading");
    currentHeading = heading.heading;
    
    [pdrController updateHeading:currentHeading];
    [pdrUpdatingController updateHeading:currentHeading];
    [pdrFusionController updateHeading:currentHeading];
    
    [self.mapView processDeviceRotation:heading.heading];
}

- (void)simulatorDidStart:(id)sender
{
    BRTLog(@"simulatorDidStart:");
    [self.stepReplayLayer reset];
    [self.locationReplayLayer reset];
    [self.updateingStepReplayLayer reset];
    [self.fusionStepReplayLayer reset];
    [pdrController reset];
    [pdrUpdatingController reset];
    [pdrFusionController reset];
}

- (void)simulatorDidCancel:(TYPDRSimulator *)simulator
{
    BRTLog(@"simulatorDidCancel");
    [self.stepReplayLayer reset];
    [self.locationReplayLayer reset];
    [self.updateingStepReplayLayer reset];
    [self.fusionStepReplayLayer reset];
    [pdrController reset];
    [pdrUpdatingController reset];
    [pdrFusionController reset];
}

@end
