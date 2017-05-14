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
    
    [simulator setReplaySpeed:1.0];
    [simulator start];
}

- (void)initMapSettings
{
    self.locationSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"l7"];
    self.locationArrowSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"locationArrow2"];
    self.locationArrowSymbol.size = CGSizeMake(60, 60);
    
    self.locationReplayLayer = [TYReplayTraceLayer newLayer:self.mapView];
//    self.locationReplayLayer.markSymbol = [self.locationArrowSymbol copy];
//    self.locationReplayLayer.markSymbol = nil;
    
    self.stepReplayLayer = [TYReplayTraceLayer newLayer:self.mapView];
    self.stepReplayLayer.lineSymbol.color = [UIColor yellowColor];

    self.signalLayer = [ArcGISHelper createNewLayer:self.mapView];
    self.locationLayer1 = [ArcGISHelper createNewLayer:self.mapView];
    
    [self.mapView setLocationSymbol:self.locationArrowSymbol];
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
    [simulator stop];
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
}

- (void)simulatorDidEnd:(id)sender
{
    BRTLog(@"simulatorDidEnd");
}

@end
