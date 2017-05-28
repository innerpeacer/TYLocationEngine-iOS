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
#import "TYStatusObject.h"

#import "t_y_raw_data_collection_pbf.pb.h"
#import "IPXPbfDBAdapter.hpp"
#import "IPXRawDataCollection.hpp"

@interface FusionPDRSimulatorVC ()<TYPDRSimulatorDelegate>
{
    TYRawDataCollection *collection;
    TYPDRSimulator *simulator;
    TYFusionPDRController *pdrFusionController;
    TYStatusObject *statusObject;
    
    AGSGraphic *testGraphic;
    
    double currentHeading;
    
    BOOL isPaused;
}

@end

@implementation FusionPDRSimulatorVC

using namespace innerpeacer::rawdata;
using namespace std;

- (void)testCppPbf
{
    BRTMethod
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"MyCollection" ofType:@"db"];
    IPXPbfDBAdapter *db = new IPXPbfDBAdapter([dbPath UTF8String]);
    db->open();
    std::vector<IPXPbfDBRecord *> pbfVector = db->getRecords(IPX_PBF_RAW_DATA);
    cout << pbfVector.size() << " Records" << endl;
    
    TYRawDataCollectionPbf dataCollection;
    IPXPbfDBRecord *record = db->getRecord([self.dataID UTF8String]);
//    cout << "Record " << record.toString() << endl;
//    dataCollection.ParseFromString(record.pbfData);
    dataCollection.ParseFromArray(record->data, record->dataLength);
//    cout << "dataCollection: " << endl;
//    cout << "\tStep: " << dataCollection.stepevents_size() << endl;
//    cout << "\tHeading: " << dataCollection.headingevents_size() << endl;
//    cout << "\tSignal: " << dataCollection.signalevents_size() << endl;
    //    cout << dataCollection.DebugString() << endl;
    
    IPXRawDataCollection rd(dataCollection);
    cout << rd.toString() << endl;
    
    db->close();
    delete db;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.dataID == nil) {
        self.dataID = @"RawData-0511-16:48:21";
    }
    
    [self testCppPbf];
    
    collection = [TYRawDataManager getData:self.dataID];
    BRTLog(@"%@", collection);
    
    simulator = [[TYPDRSimulator alloc] initWithData:collection];
    simulator.delegate = self;
    
    [self initMapSettings];
    self.mapView.allowRotationByPinching = NO;
    [self.mapView zoomToEnvelope:[AGSEnvelope envelopeWithXmin:13523497.578848 ymin:3642439.640312 xmax:13523524.595785 ymax:3642484.472765 spatialReference:self.mapView.spatialReference] animated:NO];
    
    pdrFusionController = [[TYFusionPDRController alloc] initWithAngle:0];
    statusObject = pdrFusionController.statusObject;
//    [simulator setReplaySpeed:2.0];
    //    [simulator start];
    
    
    [self.debugItems addObject:[DebugItem itemWithID:IP_DEBUG_ITEM_START_REPLAY]];
//    for (DebugItem *item in self.debugItems) {
//        if (item.on) {
//            [self performSelector:item.selector withObject:item afterDelay:0];
//        }
//    }
}

- (void)initMapSettings
{
    self.fusionStepReplayLayer = [TYReplayTraceLayer newLayer:self.mapView];
    self.fusionStepReplayLayer.lineSymbol.color = [UIColor magentaColor];
    //    self.fusionStepReplayLayer.visible = NO;
    
    AGSSimpleMarkerSymbol *testSms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor blackColor]];
    testGraphic = [AGSGraphic graphicWithGeometry:nil symbol:testSms attributes:nil];
}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
{
    //    BRTLog(@"%@", self.mapView.visibleAreaEnvelope);
    isPaused = !isPaused;
    
    if (isPaused) {
        [simulator pause];
    } else {
        [simulator resume];
    }
    
    //    if (isPaused) {
    //        [simulator cancel];
    //    } else {
    //        [simulator start];
    //    }
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
    
    [statusObject updateSignal:signal];

    [self.fusionStepReplayLayer showRef:newImmediateLocation];
    [self.fusionStepReplayLayer showFan:statusObject];
//    [self.fusionStepReplayLayer showSignalLine:statusObject];
    [self.fusionStepReplayLayer showVectorLine:[statusObject signalLine]];
    
//    [LocationTestHelper showHintRssiForLocationBeacons:[signal toPublicBeaconArray] WithMapInfo:self.currentMapInfo OnLayer:self.signalLayer];
    [LocationTestHelper showHintRssiForLocationBeacons:[statusObject firstSeveralBeacon:2] WithMapInfo:self.currentMapInfo OnLayer:self.signalLayer];
}

- (void)simulator:(id)sender replayStep:(TYRawStepEvent *)step
{
    [pdrFusionController addStepEvent];
    
//    TYVectorLine *targetLine = [[TYVectorLine alloc] initWithP1:pdrFusionController.currentLocation P2:[statusObject.currentSignal.immediateLocation toLocalPoint]];
    TYVectorLine *targetLine = [[TYVectorLine alloc] initWithP1:[statusObject.currentSignal.immediateLocation toLocalPoint] P2:pdrFusionController.currentLocation] ;

    targetLine.name = @"Target";
    [self.fusionStepReplayLayer showVectorLine:targetLine];
    
    if ([statusObject signalLine]) {
        TYVectorLine *snappedLine = [[statusObject signalLine] projectOfVectorLine:targetLine];
        snappedLine.name = @"Snapp";
        BRTLog(@"Snap: %@", snappedLine);
        [self.fusionStepReplayLayer showVectorLine:snappedLine];
        
        testGraphic.geometry = [AGSPoint pointWithX:snappedLine.x2 y:snappedLine.y2 spatialReference:nil];
        [self.fusionStepReplayLayer removeGraphic:testGraphic];
        [self.fusionStepReplayLayer addGraphic:testGraphic];
        
        [self.fusionStepReplayLayer addTracePoint:[TYLocalPoint pointWithX:snappedLine.x2 Y:snappedLine.y2] Angle:currentHeading WithNewStart:pdrFusionController.stepReseting];
    }
    
//    [self.fusionStepReplayLayer addTracePoint:pdrFusionController.currentLocation Angle:currentHeading WithNewStart:pdrFusionController.stepReseting];

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
    [pdrFusionController reset];
}

- (void)simulatorDidCancel:(TYPDRSimulator *)simulator
{
    [self.fusionStepReplayLayer reset];
    [pdrFusionController reset];
}

- (IBAction)startReplay:(id)sender
{
    //    DebugItem *item = sender;
    //    if (item.on) {
    //        [simulator start];
    //    } else {
    //        [simulator cancel];
    //    }
    [simulator cancel];
    [simulator start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [simulator cancel];
}

//+ (TYLocalPoint *)snapPoint:(TYLocalPoint *)target WithPoint1:(TYLocalPoint *)lp1 Point2:(TYLocalPoint *)lp2 Wrap:(BOOL)wrap
//{
//    
//}

@end
