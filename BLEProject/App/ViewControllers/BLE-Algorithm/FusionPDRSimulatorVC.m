//
//  FusionPDRSimulatorVC.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/15.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "FusionPDRSimulatorVC.h"
#import "TYRawDataManager.h"
#import "TYPDRSimulator.h"
#import "ArcGISHelper.h"
#import "TYSimplePDRController.h"
#import "TYFusionPDRController.h"
#import "TYFanRange.h"

@interface FusionPDRSimulatorVC ()<TYPDRSimulatorDelegate>
{
    TYRawDataCollection *collection;
    TYPDRSimulator *simulator;
    TYFusionPDRController *pdrFusionController;
    
    AGSGraphic *refGraphic;
    AGSGraphic *fanGraphic;
    
    double currentHeading;

    BOOL isPaused;
}

@end

@implementation FusionPDRSimulatorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataID = @"RawData-0511-16:48:21";
    
    collection = [TYRawDataManager getData:self.dataID];
    simulator = [[TYPDRSimulator alloc] initWithData:collection];
    simulator.delegate = self;
    
    [self initMapSettings];
    self.mapView.allowRotationByPinching = NO;
    [self.mapView zoomToEnvelope:[AGSEnvelope envelopeWithXmin:13523497.578848 ymin:3642439.640312 xmax:13523524.595785 ymax:3642484.472765 spatialReference:self.mapView.spatialReference] animated:NO];
    
    pdrFusionController = [[TYFusionPDRController alloc] initWithAngle:0];
    [simulator setReplaySpeed:3.0];
    //    [simulator start];
    
    
    [self.debugItems addObject:[DebugItem itemWithID:IP_DEBUG_ITEM_START_REPLAY]];
    for (DebugItem *item in self.debugItems) {
        if (item.on) {
            [self performSelector:item.selector withObject:item afterDelay:0];
        }
    }
}

- (void)initMapSettings
{
    self.fusionStepReplayLayer = [TYReplayTraceLayer newLayer:self.mapView];
    self.fusionStepReplayLayer.lineSymbol.color = [UIColor magentaColor];
    //    self.fusionStepReplayLayer.visible = NO;
    
    refGraphic = [AGSGraphic graphicWithGeometry:nil symbol:[AGSSimpleMarkerSymbol simpleMarkerSymbol] attributes:nil];
//    AGSSimpleFillSymbol *fanFill = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:70 green:70 blue:70 alpha:0.5] outlineColor:[UIColor whiteColor]];
    AGSSimpleFillSymbol *fanFill = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:0.5] outlineColor:[UIColor whiteColor]];
    fanGraphic = [AGSGraphic graphicWithGeometry:nil symbol:fanFill attributes:nil];
    [self.fusionStepReplayLayer addGraphic:refGraphic];
    [self.fusionStepReplayLayer addGraphic:fanGraphic];

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


- (void)simulator:(id)sender replaySignal:(TYRawSignalEvent *)signal
{
    //    BRTLog(@"replaySignal");
    TYLocalPoint *newLocation = [signal.location toLocalPoint];
    TYLocalPoint *newImmediateLocation = [signal.immediateLocation toLocalPoint];
    

    
    [self.mapView showLocation:newLocation];
    
    if (pdrFusionController.currentLocation == nil) {
        [pdrFusionController setStartLocation:newLocation];
    } else {
        [pdrFusionController updateRawSignalEvent:signal];
    }
    
    refGraphic.geometry = [AGSPoint pointWithX:newImmediateLocation.x y:newImmediateLocation.y spatialReference:nil];
    [self.fusionStepReplayLayer removeGraphic:refGraphic];
    [self.fusionStepReplayLayer addGraphic:refGraphic];
    
    TYFanRange *fan = [[TYFanRange alloc] initWithCenter:pdrFusionController.currentLocation Heading:currentHeading];
    fanGraphic.geometry = [fan toFanGeometry];
    [self.fusionStepReplayLayer removeGraphic:fanGraphic];
    [self.fusionStepReplayLayer addGraphic:fanGraphic];
    
    [LocationTestHelper showHintRssiForLocationBeacons:[signal toPublicBeaconArray] WithMapInfo:self.currentMapInfo OnLayer:self.signalLayer];
}

- (void)simulator:(id)sender replayStep:(TYRawStepEvent *)step
{
    [pdrFusionController addStepEvent];
    [self.fusionStepReplayLayer addTracePoint:pdrFusionController.currentLocation Angle:currentHeading];
}

- (void)simulator:(id)sender replayHeading:(TYRawHeadingEvent *)heading
{
    currentHeading = heading.heading;
    [pdrFusionController updateHeading:currentHeading];
    [self.mapView processDeviceRotation:heading.heading];
}

- (void)simulatorDidStart:(id)sender
{
    [self.fusionStepReplayLayer reset];
}

- (void)simulatorDidCancel:(TYPDRSimulator *)simulator
{
    [self.fusionStepReplayLayer reset];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [simulator cancel];
}

@end
