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

+ (void)drawLineFrom:(AGSPoint *)start To:(AGSPoint *)end AtLayer:(AGSGraphicsLayer *)layer WithColor:(UIColor *)color Width:(NSNumber *)width ClearContent:(BOOL)clear
{
    if (clear) {
        [layer removeAllGraphics];
    }
    
    UIColor *lineColor = color;
    if (lineColor == nil) {
        lineColor = [UIColor redColor];
    }
    
    NSNumber *lineWidth = width;
    if (lineWidth == nil) {
        lineWidth = @2;
    }
    
    AGSMutablePolyline *polyline = [[AGSMutablePolyline alloc] initWithSpatialReference:nil];
    [polyline addPathToPolyline];
    
    [polyline addPointToPath:start];
    [polyline addPointToPath:end];
    
    AGSSimpleLineSymbol *sls = [AGSSimpleLineSymbol simpleLineSymbolWithColor:lineColor width:lineWidth.doubleValue];
    [layer addGraphic:[AGSGraphic graphicWithGeometry:polyline symbol:sls attributes:nil]];
}

@end
