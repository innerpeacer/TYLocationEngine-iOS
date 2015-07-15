//
//  NPXLocationEngine.m
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "NPXLocationEngine.h"
#import "NPMotionDetector.h"

#import "ILocationEngine.h"
#import "NPXStepBasedEngine.h"
#import "IPXScannedBeacon.h"
#import "NPXBeaconDBAdapter.h"
#import "NPBeaconKey.h"
#import "NPBeaconManager.h"

#define DEFAULT_MAX_BEACON_NUMBER_FOR_PROCESSING 9

@interface NPXLocationEngine() <NPMotionDetectorDelegate, NPBeaconManagerDelegate>
{
    NPBeaconManager *beaconManager;
    CLBeaconRegion *beaconRegion;
    
    NSMutableArray *scannedBeacons;
    NSMutableDictionary *allBeacons;
    
    ILocationEngine *locationEngine;
    vector<const IPXScannedBeacon *> *pScannedBeacons;
    NPMotionDetector *motionDetector;

    BOOL isStarted;
    
    BOOL limitBeaconNumber;
    int maxBeaconNumberForProcessing;
    int rssiThreshold;
}

@end

#define RSSI_LEVEL_THRESHOLD -75
#define BEACON_NUMBER_FOR_LEVEL_CHECK 3

@implementation NPXLocationEngine

- (id)initEngineWithBeaconDBPath:(NSString *)beaconDBPath
{
    self = [super init];
    if (self) {
        limitBeaconNumber = YES;
        maxBeaconNumberForProcessing = DEFAULT_MAX_BEACON_NUMBER_FOR_PROCESSING;
        
        beaconManager = [[NPBeaconManager alloc] init];
        beaconManager.delegate = self;
        
        motionDetector = [[NPMotionDetector alloc] init];
        motionDetector.delegate = self;
        
        scannedBeacons = [[NSMutableArray alloc] init];
        allBeacons = [[NSMutableDictionary alloc] init];
        
//        locationEngine = CreateNPXStepBaseTriangulationEngine(NPXHybridSingle);
        locationEngine = CreateNPXStepBaseTriangulationEngine(NPXQuadraticWeighting);
        pScannedBeacons = new vector<const IPXScannedBeacon *>();
        
        rssiThreshold = RSSI_LEVEL_THRESHOLD;
        
        [self loadBeaconDatabase:beaconDBPath];
    }
    return self;
}



- (void)loadBeaconDatabase:(NSString *)dbPath
{
    NPXBeaconDBAdapter *db = [[NPXBeaconDBAdapter alloc] initWithDBFile:dbPath];
    [db open];
    NSArray *array = [db getAllNephogramBeacons];
    
    allBeacons = [[NSMutableDictionary alloc] init];
    vector<IPXPublicBeacon> publicBeacons;
    
    for(NPPublicBeacon *pb in array){
        NSNumber *bkey = [NPBeaconKey beaconKeyForNPBeacon:pb];
        
        [allBeacons setObject:pb forKey:bkey];
        
        IPXPoint location(pb.location.x, pb.location.y, pb.location.floor);
        IPXPublicBeacon pBeacon([pb.UUID UTF8String], pb.major.intValue, pb.minor.intValue, location);
        publicBeacons.insert(publicBeacons.end(), pBeacon);
    }
    [db close];
    
    locationEngine->Initilize(publicBeacons);
}

- (void)setBeaconRegion:(CLBeaconRegion *)region
{
    beaconRegion = [region copy];
}

- (void)setLimitBeaconNumber:(BOOL)lbn
{
    limitBeaconNumber = lbn;
}

- (void)setMaxBeaconNumberForProcessing:(int)mbn
{
    maxBeaconNumberForProcessing = mbn;
}

- (void)start
{
    NSLog(@"CppEngine Start");
    if (isStarted) {
        return;
    }
    
    isStarted = YES;
    [beaconManager startRanging:beaconRegion];
    [motionDetector startStepDetector];
    [motionDetector startHeadingDetector];
}

- (void)stop
{
    NSLog(@"CppEngine Stop");
    
    if (!isStarted) {
        return;
    }
    
    isStarted = NO;
    locationEngine->reset();
    [beaconManager stopRanging:beaconRegion];
    [motionDetector stopStepDetector];
    [motionDetector stopHeadingDetector];
}

- (void)setRssiThreshold:(int)threshold
{
    rssiThreshold = threshold;
}


- (void)beaconManager:(NPBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count == 0) {
        return;
    }
    
    [self preprocessBeacons:beacons];
    
    if (scannedBeacons.count == 0) {
        return;
    }
    
    {
        CLBeacon *firstBeacon = scannedBeacons[0];
        if (firstBeacon.rssi < rssiThreshold) {
            return;
        }
    }
    
//    int index = MIN((int)scannedBeacons.count, BEACON_NUMBER_FOR_LEVEL_CHECK);
    
    if (pScannedBeacons) {
        vector<const IPXScannedBeacon *>::iterator iter;
        for (iter = pScannedBeacons->begin(); iter != pScannedBeacons->end(); ++iter) {
            delete (*iter);
        }
        pScannedBeacons->clear();
    }
    
    if (limitBeaconNumber) {
        int index = MIN((int)scannedBeacons.count, maxBeaconNumberForProcessing);
        for(int i = 0; i < index; ++i)
        {
            CLBeacon *b = [scannedBeacons objectAtIndex:i];
            IPXScannedBeacon *pBeacon = new IPXScannedBeacon([b.proximityUUID.UUIDString UTF8String], b.major.intValue, b.minor.intValue,(int) b.rssi, b.accuracy, [self convertProximity:b.proximity]);
            pScannedBeacons->insert(pScannedBeacons->end(), pBeacon);
        }
        
    } else {
        for (CLBeacon *b in scannedBeacons) {
            IPXScannedBeacon *pBeacon = new IPXScannedBeacon([b.proximityUUID.UUIDString UTF8String], b.major.intValue, b.minor.intValue,(int) b.rssi, b.accuracy, [self convertProximity:b.proximity]);
            pScannedBeacons->insert(pScannedBeacons->end(), pBeacon);
        }
    }
    
//    NSLog(@"%d beacons scanned for processing", (int)pScannedBeacons->size());
//    if (pScannedBeacons->size() == 0) {
//        return;
//    }
    
    locationEngine->processBeacons(*pScannedBeacons);
    IPXPoint currentLocation = locationEngine->getLocation();
    
//    NSLog(@"NPX: %f, %f", currentLocation.getX(), currentLocation.getY());
    
    int currentFloor = [self calculateCurrentFloor];
    
    if (currentLocation != INVALID_POINT) {
        if ([self.delegate respondsToSelector:@selector(NPXLocationEngine:locationChanged:)]) {
            [self.delegate NPXLocationEngine:self locationChanged:[TYLocalPoint pointWithX:currentLocation.getX() Y:currentLocation.getY() Floor:currentFloor]];
        }
    }

}

- (int)calculateCurrentFloor
{
    int index = (int)MIN(9, scannedBeacons.count);
    
    NSMutableDictionary *frequencyMap = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < index; ++i) {
        CLBeacon *beacon = [scannedBeacons objectAtIndex:i];
        NSNumber *bKey = @(beacon.major.intValue * 100000 + beacon.minor.intValue);
        NPPublicBeacon *pb = [allBeacons objectForKey:bKey];
        
        if (![frequencyMap.allKeys containsObject:@(pb.location.floor)]) {
            [frequencyMap setObject:@(0) forKey:@(pb.location.floor)];
        }
        
        int count = [[frequencyMap objectForKey:@(pb.location.floor)] intValue];
        [frequencyMap setObject:@(count + 1) forKey:@(pb.location.floor)];
    }
    
    int maxCount = 0;
    int maxFloor = 1;
    for (NSNumber *floor in frequencyMap.allKeys) {
        int floorCount = [[frequencyMap objectForKey:floor] intValue];
        if (floorCount > maxCount) {
            maxCount = floorCount;
            maxFloor = floor.intValue;
        }
    }
    return maxFloor;
}

- (void)preprocessBeacons:(NSArray *)beacons
{
    [scannedBeacons removeAllObjects];
    
    for(CLBeacon *beacon in beacons) {
        if (beacon.accuracy > 0) {
            [scannedBeacons addObject:beacon];
        }
    }
    
    [scannedBeacons sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CLBeacon *b1 = (CLBeacon *)obj1;
        CLBeacon *b2 = (CLBeacon *)obj2;
        NSNumber *l1 = [NSNumber numberWithDouble:b1.accuracy];
        NSNumber *l2 = [NSNumber numberWithDouble:b2.accuracy];
        return [l1 compare:l2];
    }];
    
    NSMutableArray *toRemove = [[NSMutableArray alloc] init];
    for (CLBeacon *b in scannedBeacons) {
        NSNumber *bkey = [NPBeaconKey beaconKeyForCLBeacon:b];
        
        NPBeacon *sb = [allBeacons objectForKey:bkey];
        if (sb == nil) {
            [toRemove addObject:b];
        }
    }
    [scannedBeacons removeObjectsInArray:toRemove];
}


- (void)motionDetector:(NPMotionDetector *)detector onStepEvent:(NPStepEvent *)stepEvent
{
    locationEngine->addStepEvent();
}

- (void)motionDetector:(NPMotionDetector *)detector onHeadingChanged:(double)heading
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(NPXLocationEngine:headingChanged:)]) {
        [self.delegate NPXLocationEngine:self headingChanged:heading];
    }
}


- (void)dealloc
{
    delete locationEngine;
    if (pScannedBeacons) {
        vector<const IPXScannedBeacon *>::iterator iter;
        for (iter = pScannedBeacons->begin(); iter != pScannedBeacons->end(); ++iter) {
            delete (*iter);
        }
        pScannedBeacons->clear();
        delete pScannedBeacons;
    }
    
}

- (NPXProximity)convertProximity:(CLProximity)proxmity
{
    NPXProximity pro;
    switch (proxmity) {
        case CLProximityImmediate:
            pro = NPXProximityImmediate;
            break;
            
        case CLProximityNear:
            pro = NPXProximityNear;
            break;
            
        case CLProximityFar:
            pro = NPXProximityFar;
            break;
            
        case CLProximityUnknown:
            pro = NPXProximityUnknwon;
            break;
            
        default:
            break;
    }
    return pro;
}


@end
