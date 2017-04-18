//#import "AutoSwitchLocationEngineTestVC.h"
//#import "TYBeaconManager.h"
//
//@interface AutoSwitchLocationEngineTestVC ()
//{
//    TYLocationEngine *singleLocationEngine;
//    TYLocationEngine *trippleLocationEngine;
//    
//    // ==================================
//    int currentFloor;
//    BOOL allowAutoSwitch;
//
//}
//
//@property (weak, nonatomic) IBOutlet UISwitch *publicSwitch;
//
//@end
//
//@implementation AutoSwitchLocationEngineTestVC
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    singleLocationEngine = [TYLocationEngine locationEngineWithBeacons:self.allBeacons Type:HybridSingle];
//    trippleLocationEngine = [TYLocationEngine locationEngineWithBeacons:self.allBeacons Type:HybridTriple];
//    
//    allowAutoSwitch = YES;
//    if (allowAutoSwitch) {
//        [self.floorSegment setHidden:YES];
//    }
//}
//
//- (void)showHintRssiForBeacons:(NSArray *)beacons
//{
//    [self.hintLayer removeAllGraphics];
//    int count = (int) MIN(beacons.count, 4);
//    for (int i = 0; i < count; i++) {
//        CLBeacon *cb = [beacons objectAtIndex:i];
//        
//        for (TYPublicBeacon *pb in self.allBeacons.allValues) {
//            if (cb.minor.integerValue == pb.minor.integerValue) {
//                NSString *rssi = [NSString stringWithFormat:@"%.2f, %d", cb.accuracy,(int) cb.rssi];
//                
//                UIColor *color;
//                color = [UIColor blueColor];
//                if (i < 4) {
//                    color = [UIColor redColor];
//                }
//                
//                AGSTextSymbol *ts = [AGSTextSymbol textSymbolWithText:rssi color:color];
//                [ts setOffset:CGPointMake(5, 10)];
//                 AGSPoint *pos = [AGSPoint pointWithX:pb.location.x y:pb.location.y spatialReference:self.mapView.spatialReference];
//                AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:pos symbol:ts attributes:nil];
//                [self.hintLayer addGraphic:graphic];
//                
//                AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor redColor]];
//                sms.size = CGSizeMake(5, 5);
//                [self.hintLayer addGraphic:[AGSGraphic graphicWithGeometry:pos symbol:sms attributes:nil]];
//                break;
//            }
//        }
//    }
//}
//
//
//- (void)onStepEvent:(TYStepEvent *)stepEvent
//{
//    NSLog(@"onStepEvent");
//    [singleLocationEngine addStepEvent:stepEvent];
//    [trippleLocationEngine addStepEvent:stepEvent];
//}
//
//
//- (void)processLocationResult
//{
//    [self.resultLayer removeAllGraphics];
//    
//    {
//        [singleLocationEngine processBeacons:self.scannedBeacons];
//        TYLocalPoint *location = [singleLocationEngine getLocation];
//        if (location != nil) {
//            
//            if (allowAutoSwitch) {
//                if (currentFloor != location.floor) {
//                    BOOL targetFloorFound = NO;
//                    TYMapInfo *targetInfo = nil;
//                    for (TYMapInfo *info in self.allMapInfos) {
//                        if (info.floorNumber == location.floor) {
//                            targetFloorFound = YES;
//                            targetInfo = info;
//                            break;
//                        }
//                    }
//                    
//                    if (targetFloorFound) {
//                        self.currentMapInfo = targetInfo;
//                        self.title = targetInfo.floorName;
//                        
//                        [self.mapView setFloorWithInfo:targetInfo];
//                    } else {
//                        NSAssert(NO, @"Auto Switch and Target Floor not found");
//                        return;
//                    }
//                }
//                
//            }
//            
//            AGSPoint *pos = [AGSPoint pointWithX:location.x y:location.y spatialReference:self.mapView.spatialReference];
//            AGSPoint *snappedAgsPoint = pos;
//            
//            AGSGeometryEngine *engine = [AGSGeometryEngine defaultGeometryEngine];
//            
//            AGSPolygon *buf2m = [engine bufferGeometry:snappedAgsPoint byDistance:2.0];
//            AGSSimpleFillSymbol *sfs2m = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5] outlineColor:[UIColor blackColor]];
//            [self.resultLayer addGraphic:[AGSGraphic graphicWithGeometry:buf2m symbol:sfs2m attributes:nil]];
//            
//            AGSPolygon *buf3m = [engine bufferGeometry:snappedAgsPoint byDistance:3.0];
//            AGSSimpleFillSymbol *sfs3m = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5] outlineColor:[UIColor blackColor]];
//            [self.resultLayer addGraphic:[AGSGraphic graphicWithGeometry:buf3m symbol:sfs3m attributes:nil]];
//            
//            
//            [TYArcGISDrawer drawPoint:pos AtLayer:self.resultLayer WithColor:[UIColor greenColor] Size:CGSizeMake(8, 8)];
//            [TYArcGISDrawer drawPoint:snappedAgsPoint AtLayer:self.resultLayer WithColor:[UIColor blueColor] Size:CGSizeMake(5, 5)];
//        }
//        
//    }
//    
//    {
//        [trippleLocationEngine processBeacons:self.scannedBeacons];
//        TYLocalPoint *location = [trippleLocationEngine getLocation];
//        if (location != nil) {
//            AGSPoint *pos = [AGSPoint pointWithX:location.x y:location.y spatialReference:self.mapView.spatialReference];
//            [TYArcGISDrawer drawPoint:pos AtLayer:self.resultLayer WithColor:[UIColor blueColor] Size:CGSizeMake(5, 5)];
//        }
//    }
//}
//@end
