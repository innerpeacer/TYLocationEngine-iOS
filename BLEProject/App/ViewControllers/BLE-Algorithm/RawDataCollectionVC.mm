//
//  RawDataCollectionVC.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/9.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "RawDataCollectionVC.h"
#import "TYRawDataCollection.h"
#import "TYRawDataCollection+CppProtobuf.h"
#import "TYMotionDetector.h"
#import "TYRawDataManager.h"

@interface RawDataCollectionVC () <TYMotionDetectorDelegate>
{
    TYRawDataCollection *collection;
    TYMotionDetector *motionDetector;
    
    TYLocalPoint *currentLocation;
    TYLocalPoint *currentImmediateLocation;
    NSArray *currentBeacons;
}
@end

@implementation RawDataCollectionVC

- (void)viewDidLoad {
    self.name = @"原始数据";
    
    [super viewDidLoad];
    
    motionDetector = [[TYMotionDetector alloc] init];
    motionDetector.delegate = self;
    
    [self.debugItems addObject:[DebugItem itemWithID:IP_DEBUG_ITEM_START_RAW_DATA]];
    [self.debugItems addObject:[DebugItem itemWithID:IP_DEBUG_ITEM_SAVE_RAW_DATA]];
    
    //    [self startRawData:nil];
}

- (void)motionDetector:(TYMotionDetector *)detector onStepEvent:(TYStepEvent *)stepEvent
{
    BRTLog(@"StepEvent");
    [collection addStepEvent:[TYRawStepEvent newStepEvent]];
}


- (void)motionDetector:(TYMotionDetector *)detector onHeadingChanged:(double)heading
{
    BRTLog(@"Heading: %f", heading);
    [collection addHeadingEvent:[TYRawHeadingEvent newHeadingEvent:heading]];
}

- (void)TYLocationManager:(TYLocationManager *)manager didUpdateLocation:(TYLocalPoint *)newLocation
{
    [super TYLocationManager:manager didUpdateLocation:newLocation];
//    NSLog(@"didUpdateLocation: %@", [newLocation description]);
    currentLocation = newLocation;
}

- (void)TYLocationManager:(TYLocationManager *)manager didUpdateImmediateLocation:(TYLocalPoint *)newImmediateLocation
{
    [super TYLocationManager:manager didUpdateImmediateLocation:newImmediateLocation];
    
//    NSLog(@"didUpdateImmediateLocation: %@", [newImmediateLocation description]);
    currentImmediateLocation = newImmediateLocation;
    
    TYRawLocation *location = [TYRawLocation rawLocationWithX:currentLocation.x Y:currentLocation.y Floor:currentLocation.floor];
    TYRawLocation *immediatelocation = [TYRawLocation rawLocationWithX:currentImmediateLocation.x Y:currentImmediateLocation.y Floor:currentImmediateLocation.floor];
    
    NSMutableArray *beaconSignalArray = [NSMutableArray array];
    for (TYPublicBeacon *pb in currentBeacons) {
        TYRawBeaconSignal *beaconSingal = [TYRawBeaconSignal rawBeaconSignalWithPublicBeacon:pb];
        [beaconSignalArray addObject:beaconSingal];
    }
    
    TYRawSignalEvent *signalEvent = [TYRawSignalEvent newRawSingalEvent:BRTNow Location:location ImmediateLocation:immediatelocation SingalEvent:beaconSignalArray];
    [collection addSignalEvent:signalEvent];
}

- (void)TYLocationManager:(TYLocationManager *)manager didRangedLocationBeacons:(NSArray *)beacons
{
    [super TYLocationManager:manager didRangedLocationBeacons:beacons];
    NSLog(@"didRangedLocationBeacons:");
    currentBeacons = beacons;
}

- (void)startRawData:(id)sender
{
    BRTLog(@"startRawData");
    collection = [TYRawDataManager createNewData];
}

- (void)saveRawData:(id)sender
{
    BRTLog(@"saveRawData:");
    BRTLog(@"%@", collection);
    [TYRawDataManager saveData:collection];
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
