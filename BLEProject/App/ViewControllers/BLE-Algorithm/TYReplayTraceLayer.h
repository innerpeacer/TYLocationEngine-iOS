//
//  TYReplayTraceLayer.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/14.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "ArcGISHelper.h"
#import "TYStatusObject.h"

@interface TYReplayTraceLayer : AGSGraphicsLayer

@property (nonatomic, strong) AGSMarkerSymbol *markSymbol;
@property (nonatomic, strong) AGSSimpleLineSymbol *lineSymbol;

- (void)addTracePoint:(TYLocalPoint *)lp;
- (void)addTracePoint:(TYLocalPoint *)lp Angle:(double)angle;
- (void)addTracePoint:(TYLocalPoint *)lp Angle:(double)angle WithNewStart:(BOOL)newStart;
+ (TYReplayTraceLayer *)newLayer:(AGSMapView *)mapView;

- (void)reset;

- (void)showRef:(TYLocalPoint *)lp;
- (void)showFan:(TYStatusObject *)status;
- (void)showSignalLine:(TYStatusObject *)status;
- (void)showVectorLine:(TYVectorLine *)line;

@end
