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

@interface PDRSimulatorVC () <TYPDRSimulatorDelegate>
{
    TYRawDataCollection *collection;
    TYPDRSimulator *simulator;
    
    
    
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
    
    [simulator setReplaySpeed:2.0];
    [simulator start];
}

- (void)initMapSettings
{
    self.locationLayer1 = [ArcGISHelper createNewLayer:self.mapView];
    self.locationSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"l7"];
    self.locationArrowSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"locationArrow2"];
    self.locationArrowSymbol.size = CGSizeMake(60, 60);
    
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
    BRTLog(@"replaySignal");
    [self.mapView showLocation:[signal.location toLocalPoint]];
}

- (void)simulator:(id)sender replayStep:(TYRawStepEvent *)step
{
    BRTLog(@"replayStep");
}

- (void)simulator:(id)sender replayHeading:(TYRawHeadingEvent *)heading
{
    BRTLog(@"replayHeading");
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
