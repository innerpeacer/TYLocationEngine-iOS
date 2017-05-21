//
//  TYReplayTraceLayer.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/14.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYReplayTraceLayer.h"

@interface TYReplayTraceLayer()
{
    TYLocalPoint *lastPoint;
    TYLocalPoint *currentPoint;
}

@end

@implementation TYReplayTraceLayer

+ (TYReplayTraceLayer *)newLayer:(AGSMapView *)mapView
{
    TYReplayTraceLayer *layer = [[TYReplayTraceLayer alloc] initWithSpatialReference:nil];
    AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor greenColor]];
    sms.size = CGSizeMake(5, 5);
    sms.outline.color = [UIColor whiteColor];
    layer.markSymbol = sms;
    
    AGSSimpleLineSymbol *sls = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor redColor]];
    sls.width = 2;
    sls.style = AGSSimpleLineSymbolStyleDash;
    layer.lineSymbol = sls;
    
    if (mapView) {
        [mapView addMapLayer:layer];
    }
    return layer;
}

- (void)addTracePoint:(TYLocalPoint *)lp
{
//    [self addTracePoint:lp Angle:0];
    AGSPoint *point = [AGSPoint pointWithX:lp.x y:lp.y spatialReference:nil];
    [self addGraphic:[AGSGraphic graphicWithGeometry:point symbol:self.markSymbol attributes:nil]];
}

- (void)addTracePoint:(TYLocalPoint *)lp Angle:(double)angle WithNewStart:(BOOL)newStart
{
    //    BRTMethod
    lastPoint = currentPoint;
    currentPoint = lp;
    
    AGSPoint *newAgs = [AGSPoint pointWithX:lp.x y:lp.y spatialReference:nil];
    AGSMarkerSymbol *ms = [self.markSymbol copy];
    self.markSymbol.angle = angle;
    
    if (lastPoint && currentPoint && !newStart) {
        AGSPoint *lastAgs = [AGSPoint pointWithX:lastPoint.x y:lastPoint.y spatialReference:nil];
        [ArcGISHelper drawLineFrom:lastAgs To:newAgs AtLayer:self WithSymbol:self.lineSymbol];
    }
    [self addGraphic:[AGSGraphic graphicWithGeometry:newAgs symbol:ms attributes:nil]];
}

- (void)addTracePoint:(TYLocalPoint *)lp Angle:(double)angle
{
//    BRTMethod
    lastPoint = currentPoint;
    currentPoint = lp;
    
    AGSPoint *newAgs = [AGSPoint pointWithX:lp.x y:lp.y spatialReference:nil];
    AGSMarkerSymbol *ms = [self.markSymbol copy];
    self.markSymbol.angle = angle;
    
    if (lastPoint && currentPoint) {
        AGSPoint *lastAgs = [AGSPoint pointWithX:lastPoint.x y:lastPoint.y spatialReference:nil];
        [ArcGISHelper drawLineFrom:lastAgs To:newAgs AtLayer:self WithSymbol:self.lineSymbol];
    }
    [self addGraphic:[AGSGraphic graphicWithGeometry:newAgs symbol:ms attributes:nil]];
}

- (void)reset
{
    [self removeAllGraphics];
    lastPoint = nil;
    currentPoint = nil;
}

@end
