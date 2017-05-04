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

@interface PDRTestVC () <TYMotionDetectorDelegate, CLLocationManagerDelegate>
{
    AGSGraphicsLayer *hintLayer;
    
    TYMotionDetector *motionDetector;
    
    AGSPoint *startPoint;
    AGSPoint *currentPoint;
    AGSPoint *lastPoint;
    
    CLLocationManager *locationManager;
    
    TYPDRController *pdrController;
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
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingHeading];
    
    pdrController = [[TYPDRController alloc] initWithAngle:0];
    [pdrController setStartLocation:[TYLocalPoint pointWithX:startPoint.x Y:startPoint.y]];
}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
{
    currentPoint = startPoint;
    lastPoint = nil;
    [pdrController setStartLocation:[TYLocalPoint pointWithX:startPoint.x Y:startPoint.y]];

    [ArcGISHelper drawPoint:startPoint AtLayer:hintLayer WithSymbol:self.locationArrowSymbol ClearContent:YES];
    
    [self.mapView centerAtPoint:startPoint animated:NO];
    [self.mapView zoomToResolution:0.023484 animated:NO];
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
    
    lastPoint = currentPoint;
    currentPoint = [AGSPoint pointWithX:lp.x y:lp.y spatialReference:self.mapView.spatialReference];
    [ArcGISHelper drawPoint:currentPoint AtLayer:hintLayer WithSymbol:self.locationArrowSymbol ClearContent:YES];
    
    AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor blueColor]];
    sms.size = CGSizeMake(8, 8);
    sms.outline = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor whiteColor]];
    [ArcGISHelper drawLineFrom:lastPoint To:currentPoint AtLayer:self.traceLayer WithColor:[UIColor greenColor] Width:@4 ClearContent:NO];
    [ArcGISHelper drawPoint:lastPoint AtLayer:self.traceLayer WithSymbol:sms ClearContent:NO];
    
    [self.mapView centerAtPoint:currentPoint animated:YES];
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
