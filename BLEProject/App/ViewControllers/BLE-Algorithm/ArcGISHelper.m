//
//  GraphicDrawer.m
//  BLEProject
//
//  Created by innerpeacer on 2017/4/19.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "ArcGISHelper.h"

@implementation ArcGISHelper

+ (AGSGraphicsLayer *)createNewLayer
{
    AGSGraphicsLayer *layer = [AGSGraphicsLayer graphicsLayer];
    return layer;
}

+ (AGSGraphicsLayer *)createNewLayer:(AGSMapView *)mapView
{
    AGSGraphicsLayer *layer = [AGSGraphicsLayer graphicsLayer];
    [mapView addMapLayer:layer];
    return layer;
}

+ (void)drawLocalPoint:(TYLocalPoint *)lp AtLayer:(AGSGraphicsLayer *)layer WithSymbol:(AGSMarkerSymbol *)ms ClearContent:(BOOL)clear
{
    AGSPoint *point = [AGSPoint pointWithX:lp.x y:lp.y spatialReference:nil];
    [ArcGISHelper drawPoint:point AtLayer:layer WithSymbol:ms ClearContent:clear];
}

+ (void)drawPoint:(AGSPoint *)p AtLayer:(AGSGraphicsLayer *)layer WithSymbol:(AGSMarkerSymbol *)ms ClearContent:(BOOL)clear
{
    if (clear) {
        [layer removeAllGraphics];
    }
    
    if (ms) {
        [layer addGraphic:[AGSGraphic graphicWithGeometry:p symbol:ms attributes:nil]];
    } else {
        AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor greenColor]];
        sms.outline = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor greenColor]];
        [layer addGraphic:[AGSGraphic graphicWithGeometry:p symbol:sms attributes:nil]];
    }
}


+ (void)drawLineFrom:(AGSPoint *)start To:(AGSPoint *)end AtLayer:(AGSGraphicsLayer *)layer WithSymbol:(AGSSimpleLineSymbol *)sls
{
    AGSMutablePolyline *polyline = [[AGSMutablePolyline alloc] initWithSpatialReference:nil];
    [polyline addPathToPolyline];
    
    [polyline addPointToPath:start];
    [polyline addPointToPath:end];
    [layer addGraphic:[AGSGraphic graphicWithGeometry:polyline symbol:sls attributes:nil]];
}


+ (void)drawLineFrom:(AGSPoint *)start To:(AGSPoint *)end AtLayer:(AGSGraphicsLayer *)layer WithColor:(UIColor *)color Width:(NSNumber *)width ClearContent:(BOOL)clear
{
    if (clear) {
        [layer removeAllGraphics];
    }
    
    UIColor *lineColor = (color == nil) ? [UIColor redColor] : color;
    NSNumber *lineWidth = (width == nil) ? @2 : width;
    
    AGSMutablePolyline *polyline = [[AGSMutablePolyline alloc] initWithSpatialReference:nil];
    [polyline addPathToPolyline];
    
    [polyline addPointToPath:start];
    [polyline addPointToPath:end];
    
    AGSSimpleLineSymbol *sls = [AGSSimpleLineSymbol simpleLineSymbolWithColor:lineColor width:lineWidth.doubleValue];
    [layer addGraphic:[AGSGraphic graphicWithGeometry:polyline symbol:sls attributes:nil]];
}

+ (void)drawTrace:(TYTrace *)trace AtLayer:(AGSGraphicsLayer *)layer
{
    [ArcGISHelper drawTrace:trace AtLayer:layer PointColor:nil LineColor:nil Width:nil];
}

+ (void)drawTrace:(TYTrace *)trace AtLayer:(AGSGraphicsLayer *)layer PointColor:(UIColor *)pColor LineColor:(UIColor *)lColor Width:(NSNumber *)width
{
    UIColor *pointColor = (pColor == nil) ? [UIColor blueColor] : pColor;
    AGSSimpleMarkerSymbol *pointSymbol = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:pointColor];
    pointSymbol.size = CGSizeMake(6, 6);
    pointSymbol.outline = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor whiteColor]];
    
    UIColor *lineColor = (lColor == nil) ? [UIColor greenColor] : lColor;
    NSNumber *lineWidth = (width == nil) ? @4 : width;
    
    [layer removeAllGraphics];
    for (int i = 0; i < trace.points.count; ++i) {
        TYTracePoint *tp = trace.points[i];
        AGSPoint *currentPoint = [AGSPoint pointWithX:tp.x y:tp.y spatialReference:nil];
        if (i > 0) {
            TYTracePoint *lastTP = trace.points[i - 1];
            AGSPoint *lastPoint = [AGSPoint pointWithX:lastTP.x y:lastTP.y spatialReference:nil];
            [ArcGISHelper drawLineFrom:lastPoint To:currentPoint AtLayer:layer WithColor:lineColor Width:lineWidth ClearContent:NO];
        }
    }
    
    for (int i = 0; i < trace.points.count; ++i) {
        TYTracePoint *tp = trace.points[i];
        AGSPoint *currentPoint = [AGSPoint pointWithX:tp.x y:tp.y spatialReference:nil];
        [ArcGISHelper drawPoint:currentPoint AtLayer:layer WithSymbol:pointSymbol ClearContent:NO];
    }
    
}

@end
