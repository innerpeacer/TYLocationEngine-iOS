//
//  PDRTestVC.m
//  BLEProject
//
//  Created by innerpeacer on 2017/4/19.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "PDRTestVC.h"
#import "ArcGISHelper.h"
#import "TYMotionDetector.h"

#import <CoreLocation/CoreLocation.h>
#import "TYPDRController.h"
#import "TYTrace.h"
#import "TYTrace+Protobuf.h"

@interface PDRTestVC () <TYMotionDetectorDelegate, CLLocationManagerDelegate>
{
    AGSGraphicsLayer *hintLayer;
    
    TYMotionDetector *motionDetector;
    
    AGSPoint *startPoint;
    AGSPoint *currentPoint;
    AGSPoint *lastPoint;
    
    CLLocationManager *locationManager;
    
    TYPDRController *pdrController;
    
    TYTrace *pdrTrace;
}

@end

@implementation PDRTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hintLayer = [ArcGISHelper createNewLayer:self.mapView];
    
    motionDetector = [[TYMotionDetector alloc] init];
    motionDetector.delegate = self;
    
    startPoint = [AGSPoint pointWithX:13523504.992997 y:3642473.329817 spatialReference:self.mapView.spatialReference];
    currentPoint = startPoint;
    lastPoint = nil;
    
    pdrTrace = [[TYTrace alloc] initWithTraceID:@"trace-0"];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingHeading];
    
    pdrController = [[TYPDRController alloc] initWithAngle:0];
    [pdrController setStartLocation:[TYLocalPoint pointWithX:startPoint.x Y:startPoint.y]];
    
    [self.debugItems addObject:[DebugItem itemWithID:IP_DEBUG_ITEM_SAVE_TRACE]];
    [self.debugItems addObject:[DebugItem itemWithID:IP_DEBUG_ITEM_SHOW_TRACE]];

}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
{
    currentPoint = startPoint;
    lastPoint = nil;
    [pdrController setStartLocation:[TYLocalPoint pointWithX:startPoint.x Y:startPoint.y]];

    [ArcGISHelper drawPoint:startPoint AtLayer:hintLayer WithSymbol:self.locationArrowSymbol ClearContent:YES];
    
//    [self.mapView centerAtPoint:startPoint animated:NO];
//    [self.mapView zoomToResolution:0.023484 animated:NO];
    
    [pdrTrace addTracePointWithX:mappoint.x Y:mappoint.y Floor:22];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
//    BRTLog(@"LocationHeading: %f", newHeading.trueHeading);
//    arrowSymbol.angle = newHeading.trueHeading;
}

- (void)motionDetector:(TYMotionDetector *)detector onHeadingChanged:(double)heading
{
//    BRTLog(@"Heading: %f", heading);
    self.locationArrowSymbol.angle = heading;
    [pdrController updateHeading:heading];
    
}

- (void)motionDetector:(TYMotionDetector *)detector onStepEvent:(TYStepEvent *)stepEvent
{
//    BRTLog(@"StepEvent");
    [pdrController addStepEvent];
    TYLocalPoint *lp = pdrController.currentLocation;
    
//    lastPoint = currentPoint;
    currentPoint = [AGSPoint pointWithX:lp.x y:lp.y spatialReference:self.mapView.spatialReference];
    [ArcGISHelper drawPoint:currentPoint AtLayer:hintLayer WithSymbol:self.locationArrowSymbol ClearContent:YES];
//
//    AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor blueColor]];
//    sms.size = CGSizeMake(8, 8);
//    sms.outline = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor whiteColor]];
//    [ArcGISHelper drawLineFrom:lastPoint To:currentPoint AtLayer:self.traceLayer WithColor:[UIColor greenColor] Width:@4 ClearContent:NO];
//    [ArcGISHelper drawPoint:lastPoint AtLayer:self.traceLayer WithSymbol:sms ClearContent:NO];
//    
//    [self.mapView centerAtPoint:currentPoint animated:YES];
    
//    [pdrTrace addTracePoint:tp];
    [pdrTrace addTracePointWithX:lp.x Y:lp.y Floor:lp.floor];
    [ArcGISHelper drawTrace:pdrTrace AtLayer:self.traceLayer];
}

- (void)showTrace:(id)sender
{
    BRTLog(@"showTrace");
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSData *pdrData = [NSData dataWithContentsOfFile:[documentDirectory stringByAppendingPathComponent:@"trace.pbf"]];
    TYTrace *trace = [TYTrace traceWithData:pdrData error:nil];
    [ArcGISHelper drawTrace:trace AtLayer:self.traceLayer PointColor:nil LineColor:nil Width:nil];
    BRTLog(@"%@", trace);
}

- (void)saveTrace:(id)sender
{
    BRTLog(@"saveTrace");
    NSData *pdrData = [pdrTrace data];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [pdrData writeToFile:[documentDirectory stringByAppendingPathComponent:@"trace.pbf"] atomically:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [motionDetector startHeadingDetector];
    [motionDetector startStepDetector];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [motionDetector stopAllDetectors];
}

@end
