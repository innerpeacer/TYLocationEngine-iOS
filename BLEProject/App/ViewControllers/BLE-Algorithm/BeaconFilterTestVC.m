//
//  BeaconFilterTest.m
//  BLEProject
//
//  Created by innerpeacer on 15/1/30.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "BeaconFilterTestVC.h"
#import "TYGeometryFactory.h"
#import "TYBeaconFilter.h"
#import "BLELocationEngineConstants.h"
#import "TYBeaconPool.h"
#import "TYBeaconKey.h"

@interface BeaconFilterTestVC()
{
    TYBeaconPool *beaconPool;
}

@end

@implementation BeaconFilterTestVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    beaconPool = [[TYBeaconPool alloc] initWithValidTime:3];
}

- (void)showHintRssiForBeacons:(NSArray *)scannedBeacons
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.hintLayer removeAllGraphics];
    
    [beaconPool pushBeacons:scannedBeacons];
    NSArray *beaconFromPool = [beaconPool getScannedBeaconsInPool];
    
    int count = (int)beaconFromPool.count;
    
    for (int i = 0; i < count; i++) {
        CLBeacon *cb = [beaconFromPool objectAtIndex:i];
        
        for (TYPublicBeacon *pb in self.allBeacons.allValues) {
            if (cb.minor.integerValue == pb.minor.integerValue) {
                NSString *rssi = [NSString stringWithFormat:@"%.2f, %d", cb.accuracy,(int) cb.rssi];
                AGSTextSymbol *ts = [AGSTextSymbol textSymbolWithText:rssi color:[UIColor blueColor]];
                [ts setOffset:CGPointMake(5, 10)];
                AGSPoint *pos = [AGSPoint pointWithX:pb.location.x y:pb.location.y spatialReference:self.mapView.spatialReference];
                AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:pos symbol:ts attributes:nil];
                [self.hintLayer addGraphic:graphic];
                
                AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor redColor]];
                sms.size = CGSizeMake(5, 5);
                [self.hintLayer addGraphic:[AGSGraphic graphicWithGeometry:pos symbol:sms attributes:nil]];
                break;
            }
        }
    }
    
    [self.hintPolygonLayer removeAllGraphics];
    
    {
        CABeaconFilterType rangeFilterType = RANGE;
        TYBeaconFilter *rangeBeaconFilter = [TYBeaconFilter beaconFilterWithType:rangeFilterType];
        NSArray *beaconsWithRangeFilter = [rangeBeaconFilter filterBeaconFrom:beaconFromPool withBeaconDict:self.allBeacons];
        NSMutableArray *pointsWithRangeFilter = [NSMutableArray array];
        
        for (int i = 0; i < beaconsWithRangeFilter.count; i++) {
            CLBeacon *cb = beaconsWithRangeFilter[i];
            NSNumber *key = [TYBeaconKey beaconKeyForCLBeacon:cb];
            TYPublicBeacon *pb = self.allBeacons[key];
            [pointsWithRangeFilter addObject:pb.location];
        }
        AGSPolygon *polygonRange = [TYGeometryFactory convexHullFromPoints:pointsWithRangeFilter];
        AGSSimpleFillSymbol *sfsRange = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:0.3] outlineColor:[UIColor redColor]];
        [self.hintPolygonLayer addGraphic:[AGSGraphic graphicWithGeometry:polygonRange symbol:sfsRange attributes:nil]];
    }
    
    {
        CABeaconFilterType rssiFilterType = RSSI;
        TYBeaconFilter *rssiBeaconFilter = [TYBeaconFilter beaconFilterWithType:rssiFilterType];
        NSArray *beaconsWithRssiFilter = [rssiBeaconFilter filterBeaconFrom:beaconFromPool withBeaconDict:self.allBeacons];
        NSMutableArray *pointsWithRssiFilter = [NSMutableArray array];
        
        for (int i = 0; i < beaconsWithRssiFilter.count; i++) {
            CLBeacon *cb = beaconsWithRssiFilter[i];
            NSNumber *key = [TYBeaconKey beaconKeyForCLBeacon:cb];
            TYPublicBeacon *pb = self.allBeacons[key];
            [pointsWithRssiFilter addObject:pb.location];
        }
        AGSPolygon *polygonRssi = [TYGeometryFactory convexHullFromPoints:pointsWithRssiFilter];
        AGSSimpleFillSymbol *sfsRssi = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.5 alpha:0.3] outlineColor:[UIColor redColor]];
        [self.hintPolygonLayer addGraphic:[AGSGraphic graphicWithGeometry:polygonRssi symbol:sfsRssi attributes:nil]];
    }
}

@end
