//
//  BaseLocationTestVC.m
//  BLEProject
//
//  Created by innerpeacer on 15/1/27.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "BaseLocationTestVC.h"
#import "BLELocationEngineConstants.h"
#import "TYMotionDetector.h"
#import "TYBeaconKey.h"

@interface BaseLocationTestVC () <TYBeaconManagerDelegate, TYMotionDetectorDelegate>
{
    TYGraphicsLayer *publicBeaconLayer;
}

@property (nonatomic, strong) TYMotionDetector *motionDetector;
@property (nonatomic, strong) TYBeaconManager *beaconManager;

@property (weak, nonatomic) IBOutlet UISwitch *publicSwitch;
- (IBAction)publicSwitchToggled:(id)sender;

@end

@implementation BaseLocationTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setHighlightPOIOnSelection:NO];
    
    [self addLayers];
    [self initLocationSettings];
    
    self.motionDetector = [[TYMotionDetector alloc] init];
    self.motionDetector.delegate = self;
}

- (void)addLayers
{
    self.hintLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.hintLayer];
    
    self.hintPolygonLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.hintPolygonLayer];
    
    publicBeaconLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:publicBeaconLayer];
    
    self.resultLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.resultLayer];
}

- (void)initLocationSettings
{
    self.beaconManager = [[TYBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    self.publicBeaconRegion = [TYRegionManager defaultRegion];
    
    self.scannedBeacons = [[NSMutableArray alloc] init];
    self.allBeacons = [[NSMutableDictionary alloc] init];
    
    if (self.currentBuilding != nil) {
        TYBeaconFMDBAdapter *db = [[TYBeaconFMDBAdapter alloc] initWithBuilding:self.currentBuilding];
        [db open];
        NSArray *array = [db getAllLocationingBeacons];
        for(TYPublicBeacon *pb in array){
            NSNumber *key = [TYBeaconKey beaconKeyForTYBeacon:pb];
            [self.allBeacons setObject:pb forKey:key];
        }
        [db close];
    }
}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
{
    NSLog(@"didClickAtPoint: %f, %f", mappoint.x, mappoint.y);
    NSLog(@"MapAngle: %f", self.mapView.rotationAngle);
}

- (IBAction)publicSwitchToggled:(id)sender {
    if (self.publicSwitch.on) {
                
        TYBeaconFMDBAdapter *pdb = [[TYBeaconFMDBAdapter alloc] initWithBuilding:self.currentBuilding];
        [pdb open];
        
        NSArray *array = [pdb getAllLocationingBeacons];
        
        for (TYPublicBeacon *pb in array)
        {
            if (pb.location.floor != self.currentMapInfo.floorNumber && pb.location.floor != 0) {
                continue;
            }
            
            TYPoint *p = [TYPoint pointWithX:pb.location.x y:pb.location.y spatialReference:self.mapView.spatialReference];
            [TYArcGISDrawer drawPoint:p AtLayer:publicBeaconLayer WithColor:[UIColor redColor]];
            
//            NSLog(@"{uuid:%@, major:%@, minor:%@, x:%f, y:%f, floor:%d", pb.UUID, pb.major, pb.minor, pb.location.x, pb.location.y, pb.location.floor);
            
            AGSTextSymbol *ts = [AGSTextSymbol textSymbolWithText:[NSString stringWithFormat:@"%@\n%@", pb.minor, pb.tag] color:[UIColor magentaColor]];
            [ts setOffset:CGPointMake(5, -20)];
            [publicBeaconLayer addGraphic:[AGSGraphic graphicWithGeometry:p symbol:ts attributes:nil]];
            
        }
        [pdb close];
        
        // Generate Beacon Json File for Web Map
        {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSMutableArray *beaconArray = [NSMutableArray array];
        for (TYPublicBeacon *pb in array) {
            NSMutableDictionary *beaconDict = [NSMutableDictionary dictionary];
            [beaconDict setObject:pb.UUID forKey:@"uuid"];
            [beaconDict setObject:pb.major forKey:@"major"];
            [beaconDict setObject:pb.minor forKey:@"minor"];
            
            [beaconDict setObject:@(pb.location.x) forKey:@"x"];
            [beaconDict setObject:@(pb.location.y) forKey:@"y"];
            [beaconDict setObject:@(pb.location.floor) forKey:@"floor"];
            
            [beaconArray addObject:beaconDict];
        }
            [dict setObject:beaconArray forKey:@"beacons"];
                     
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            NSString *beaconJsonPath = [documentDirectory stringByAppendingPathComponent:@"beacon.json"];
            
            NSData *beaconData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            [beaconData writeToFile:beaconJsonPath atomically:YES];
        }
        
    } else {
        [publicBeaconLayer removeAllGraphics];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.beaconManager startRanging:self.publicBeaconRegion];
    [self.motionDetector startStepDetector];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.beaconManager stopRanging:self.publicBeaconRegion];
    [self.motionDetector stopStepDetector];
}

- (void)preprocessBeacons:(NSArray *)beacons
{
    [self.scannedBeacons removeAllObjects];
    
    for(CLBeacon *beacon in beacons) {
        if (beacon.accuracy > 0) {
            [self.scannedBeacons addObject:beacon];
        }
    }
    
    [self.scannedBeacons sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CLBeacon *b1 = (CLBeacon *)obj1;
        CLBeacon *b2 = (CLBeacon *)obj2;
        
        NSNumber *l1 = [NSNumber numberWithDouble:b1.rssi];
        NSNumber *l2 = [NSNumber numberWithDouble:b2.rssi];
        return ![l1 compare:l2];
    }];
    
    NSMutableArray *toRemove = [[NSMutableArray alloc] init];
    for (CLBeacon *b in self.scannedBeacons) {
        NSNumber *key = [TYBeaconKey beaconKeyForCLBeacon:b];
        
        TYBeacon *sb = [self.allBeacons objectForKey:key];
        
        if (sb == nil) {
            [toRemove addObject:b];
        }
    }
    [self.scannedBeacons removeObjectsInArray:toRemove];
}

- (void)showHintRssiForBeacons:(NSArray *)beacons
{

}

- (void)motionDetector:(TYMotionDetector *)detector onStepEvent:(TYStepEvent *)stepEvent
{
    [self onStepEvent:stepEvent];
}

- (void)onStepEvent:(TYStepEvent *)stepEvent
{

}

- (void)beaconManager:(TYBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count == 0) {
        return;
    }
    
    [self preprocessBeacons:beacons];
    [self processLocationResult];
    [self showHintRssiForBeacons:self.scannedBeacons];
}

- (void)processLocationResult
{

}

@end
