//
//  BeaconFilterTest.m
//  CloudAtlasTestProject
//
//  Created by innerpeacer on 15/1/30.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "BeaconFilterTestVC.h"
#import "NPGeometryFactory.h"
#import "NPBeaconFilter.h"
#import "NephogramConstants.h"
#import "NPBeaconPool.h"
#import "NPBeaconKey.h"

@interface BeaconFilterTestVC()
{
    NPBeaconPool *beaconPool;
}

@end

@implementation BeaconFilterTestVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    beaconPool = [[NPBeaconPool alloc] initWithValidTime:3];
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
        
        for (NPPublicBeacon *pb in self.allBeacons.allValues) {
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
        NPBeaconFilter *rangeBeaconFilter = [NPBeaconFilter beaconFilterWithType:rangeFilterType];
        NSArray *beaconsWithRangeFilter = [rangeBeaconFilter filterBeaconFrom:beaconFromPool withBeaconDict:self.allBeacons];
        NSMutableArray *pointsWithRangeFilter = [NSMutableArray array];
        
        for (int i = 0; i < beaconsWithRangeFilter.count; i++) {
            CLBeacon *cb = beaconsWithRangeFilter[i];
            NSNumber *key = [NPBeaconKey beaconKeyForCLBeacon:cb];
            NPPublicBeacon *pb = self.allBeacons[key];
            [pointsWithRangeFilter addObject:pb.location];
        }
        AGSPolygon *polygonRange = [NPGeometryFactory convexHullFromPoints:pointsWithRangeFilter];
        AGSSimpleFillSymbol *sfsRange = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:0.3] outlineColor:[UIColor redColor]];
        [self.hintPolygonLayer addGraphic:[AGSGraphic graphicWithGeometry:polygonRange symbol:sfsRange attributes:nil]];
    }
    
    {
        CABeaconFilterType rssiFilterType = RSSI;
        NPBeaconFilter *rssiBeaconFilter = [NPBeaconFilter beaconFilterWithType:rssiFilterType];
        NSArray *beaconsWithRssiFilter = [rssiBeaconFilter filterBeaconFrom:beaconFromPool withBeaconDict:self.allBeacons];
        NSMutableArray *pointsWithRssiFilter = [NSMutableArray array];
        
        for (int i = 0; i < beaconsWithRssiFilter.count; i++) {
            CLBeacon *cb = beaconsWithRssiFilter[i];
            NSNumber *key = [NPBeaconKey beaconKeyForCLBeacon:cb];
            NPPublicBeacon *pb = self.allBeacons[key];
            [pointsWithRssiFilter addObject:pb.location];
        }
        AGSPolygon *polygonRssi = [NPGeometryFactory convexHullFromPoints:pointsWithRssiFilter];
        AGSSimpleFillSymbol *sfsRssi = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.5 alpha:0.3] outlineColor:[UIColor redColor]];
        [self.hintPolygonLayer addGraphic:[AGSGraphic graphicWithGeometry:polygonRssi symbol:sfsRssi attributes:nil]];
    }
}

@end
