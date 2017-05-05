//
//  GraphicDrawer.h
//  BLEProject
//
//  Created by innerpeacer on 2017/4/19.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "TYTrace.h"

@interface ArcGISHelper : NSObject

+ (AGSGraphicsLayer *)createNewLayer;
+ (AGSGraphicsLayer *)createNewLayer:(AGSMapView *)mapView;

+ (void)drawPoint:(AGSPoint *)p AtLayer:(AGSGraphicsLayer *)layer WithSymbol:(AGSMarkerSymbol *)ms ClearContent:(BOOL)clear;
+ (void)drawLineFrom:(AGSPoint *)start To:(AGSPoint *)end AtLayer:(AGSGraphicsLayer *)layer WithColor:(UIColor *)color Width:(NSNumber *)width ClearContent:(BOOL)clear;

+ (void)drawTrace:(TYTrace *)trace AtLayer:(AGSGraphicsLayer *)layer;
+ (void)drawTrace:(TYTrace *)trace AtLayer:(AGSGraphicsLayer *)layer PointColor:(UIColor *)pColor LineColor:(UIColor *)lColor Width:(NSNumber *)width;
@end
