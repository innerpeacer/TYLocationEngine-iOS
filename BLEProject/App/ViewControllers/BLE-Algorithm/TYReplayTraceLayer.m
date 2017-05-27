//
//  TYReplayTraceLayer.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/14.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYReplayTraceLayer.h"
#import "StatusDebugHelper.h"
@interface TYReplayTraceLayer()
{
    TYLocalPoint *lastPoint;
    TYLocalPoint *currentPoint;
    
    AGSGraphic *fanGraphic;
    AGSGraphic *refGraphic;
    AGSGraphic *signalLineGraphic;
    
    NSMutableDictionary *vectorLineDict;
}

@end

@implementation TYReplayTraceLayer

+ (TYReplayTraceLayer *)newLayer:(AGSMapView *)mapView
{
    TYReplayTraceLayer *layer = [[TYReplayTraceLayer alloc] initWithSpatialReference:nil];
    
    if (mapView) {
        [mapView addMapLayer:layer];
    }
    return layer;
}

- (id)initWithSpatialReference:(AGSSpatialReference *)sr
{
    self = [super initWithSpatialReference:sr];
    if (self) {
        AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor greenColor]];
        sms.size = CGSizeMake(5, 5);
        sms.outline.color = [UIColor whiteColor];
        _markSymbol = sms;
        
        AGSSimpleLineSymbol *sls = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor redColor]];
        sls.width = 2;
        sls.style = AGSSimpleLineSymbolStyleDash;
        _lineSymbol = sls;
        
        AGSSimpleFillSymbol *fanFill = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:0.5] outlineColor:[UIColor whiteColor]];
        fanGraphic = [AGSGraphic graphicWithGeometry:nil symbol:fanFill attributes:nil];
        
        refGraphic = [AGSGraphic graphicWithGeometry:nil symbol:[AGSSimpleMarkerSymbol simpleMarkerSymbol] attributes:nil];
        
        AGSSimpleLineSymbol *signalSymbol = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor yellowColor] width:2];
        signalLineGraphic = [AGSGraphic graphicWithGeometry:nil symbol:signalSymbol attributes:nil];
        
        vectorLineDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)showVectorLine:(TYVectorLine *)line
{
    if (![vectorLineDict.allKeys containsObject:line.name]) {
        AGSSimpleLineSymbol *signalSymbol = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[StatusDebugHelper randomColorFromName:line.name] width:2];
        AGSGraphic *lineGraphic = [AGSGraphic graphicWithGeometry:nil symbol:signalSymbol attributes:nil];
        vectorLineDict[line.name] = lineGraphic;
    }
    
    AGSGraphic *lineGrahpic = vectorLineDict[line.name];
    lineGrahpic.geometry = [line toGeometry];
//    BRTLog(@"%@", [line toGeometry]);
    [self removeGraphic:lineGrahpic];
    [self addGraphic:lineGrahpic];
}

- (void)showRef:(TYLocalPoint *)lp
{
    refGraphic.geometry = [AGSPoint pointWithX:lp.x y:lp.y spatialReference:nil];
    [self removeGraphic:refGraphic];
    [self addGraphic:refGraphic];
}

- (void)showFan:(TYStatusObject *)status
{
    [self updateGraphicSymbol:status.rangeStatus];
    fanGraphic.geometry = status.fan;
    [self removeGraphic:fanGraphic];
    [self addGraphic:fanGraphic];
}

- (void)showSignalLine:(TYStatusObject *)status
{
    signalLineGraphic.geometry = [status.signalLine toGeometry];
    [self removeGraphic:signalLineGraphic];
    [self addGraphic:signalLineGraphic];
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

- (void)updateGraphicSymbol:(LocationRangeStatus)status
{
    switch (status) {
        case IP_Contain:
            fanGraphic.symbol.color = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5];
            break;
            
        case IP_Forward:
            fanGraphic.symbol.color = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
            break;
            
        case IP_Backward:
            fanGraphic.symbol.color = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5];
            break;
            
        default:
            fanGraphic.symbol.color = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:0.5];
            break;
    }
}

@end
