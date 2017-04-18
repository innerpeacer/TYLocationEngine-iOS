//#import "LocationEngineTestVC.h"
//#import "TYLocationEngine.h"
//
//#import "TYGeometryFactory.h"
//
//@interface LocationEngineTestVC()
//{
//    TYLocationEngine *singleLocationEngine;
//    TYLocationEngine *trippleLocationEngine;
//}
//
//@property (weak, nonatomic) IBOutlet UISwitch *publicSwitch;
//
//@end
//@implementation LocationEngineTestVC
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    singleLocationEngine = [TYLocationEngine locationEngineWithBeacons:self.allBeacons Type:HybridSingle];
//    trippleLocationEngine = [TYLocationEngine locationEngineWithBeacons:self.allBeacons Type:HybridTriple];
//}
//
//- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
//{
//    NSLog(@"%f, %f", mappoint.x, mappoint.y);
//}
//
//- (void)showHintRssiForBeacons:(NSArray *)beacons
//{
//    [self.hintLayer removeAllGraphics];
//    int count = (int) MIN(beacons.count, 4);
//    
//    NSMutableArray *usedBeaconPoints = [NSMutableArray array];
//    
//    for (int i = 0; i < count; i++) {
//        CLBeacon *cb = [beacons objectAtIndex:i];
//        
//        for (TYPublicBeacon *pb in self.allBeacons.allValues) {
//            if (cb.minor.integerValue == pb.minor.integerValue) {
//                
//                NSString *rssi = [NSString stringWithFormat:@"%.2f, %d", cb.accuracy,(int) cb.rssi];
//                AGSTextSymbol *ts = [AGSTextSymbol textSymbolWithText:rssi color:[UIColor blueColor]];
//                [ts setOffset:CGPointMake(5, 10)];
//                AGSPoint *pos = [AGSPoint pointWithX:pb.location.x y:pb.location.y spatialReference:self.mapView.spatialReference];
//                AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:pos symbol:ts attributes:nil];
//                [self.hintLayer addGraphic:graphic];
//                
//                AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor redColor]];
//                sms.size = CGSizeMake(5, 5);
//                [self.hintLayer addGraphic:[AGSGraphic graphicWithGeometry:pos symbol:sms attributes:nil]];
//                [usedBeaconPoints addObject:pos];
//                
//                break;
//            }
//        }
//    }
//    
//    [self.hintPolygonLayer removeAllGraphics];
//    AGSPolygon *polygon = [TYGeometryFactory convexHullFromPoints:usedBeaconPoints];
//    AGSSimpleFillSymbol *sfs = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:0.5] outlineColor:[UIColor redColor]];
//    [self.hintPolygonLayer addGraphic:[AGSGraphic graphicWithGeometry:polygon symbol:sfs attributes:nil]];
//}
//
//- (void)onStepEvent:(TYStepEvent *)stepEvent
//{
//    NSLog(@"onStepEvent");
//    
//    [singleLocationEngine addStepEvent:stepEvent];
//    [trippleLocationEngine addStepEvent:stepEvent];
//}
//
//- (void)processLocationResult
//{
//    [self.resultLayer removeAllGraphics];
//    
//    {
//        [singleLocationEngine processBeacons:self.scannedBeacons];
//        TYLocalPoint *location = [singleLocationEngine getLocation];
//        TYLocalPoint *directLocation = [singleLocationEngine getDirectioLocation];
//        if (location != nil) {
//            AGSPoint *pos = [AGSPoint pointWithX:location.x y:location.y spatialReference:self.mapView.spatialReference];
//            [TYArcGISDrawer drawPoint:pos AtLayer:self.resultLayer WithBuffer1:2.0 Buffer2:3.0];
//            
//            AGSPoint *directPos = [AGSPoint pointWithX:directLocation.x y:directLocation.y spatialReference:self.mapView.spatialReference];
//            [TYArcGISDrawer drawPoint:directPos AtLayer:self.resultLayer WithColor:[UIColor greenColor] Size:CGSizeMake(3, 3)];
//        }
//    }
//    
//    // =========================================================================
//    {
//        [trippleLocationEngine processBeacons:self.scannedBeacons];
//        TYLocalPoint *location = [trippleLocationEngine getLocation];
//        TYLocalPoint *directLocation = [trippleLocationEngine getDirectioLocation];
//        if (location != nil) {
//            AGSPoint *pos = [AGSPoint pointWithX:location.x y:location.y spatialReference:self.mapView.spatialReference];
//            [TYArcGISDrawer drawPoint:pos AtLayer:self.resultLayer WithColor:[UIColor blueColor] Size:CGSizeMake(8, 8)];
//            
//            AGSPoint *directPos = [AGSPoint pointWithX:directLocation.x y:directLocation.y spatialReference:self.mapView.spatialReference];
//            [TYArcGISDrawer drawPoint:directPos AtLayer:self.resultLayer WithColor:[UIColor blueColor] Size:CGSizeMake(3, 3)];
//        }
//    }
//    
//}
//
//
//@end
