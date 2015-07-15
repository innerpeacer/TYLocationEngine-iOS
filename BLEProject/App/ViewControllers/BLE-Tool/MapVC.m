#import "MapVC.h"

#import <TYMapSDK/TYMapSDK.h>

#import "TYGeometryFactory.h"
#import "TYVector2.h"

@interface MapVC()
{
    TYGraphicsLayer *hintLayer;
    TYGraphicsLayer *graphicLayer;
    
    NSMutableArray *pointsArray;
}

- (IBAction)buttonClicked:(id)sender;
@end

@implementation MapVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    hintLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:hintLayer];
    
    graphicLayer = [TYGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:graphicLayer];
    
    pointsArray = [[NSMutableArray alloc] init];
}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
{
    NSLog(@"%f, %f", mappoint.x, mappoint.y);
    
    AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor greenColor]];
    sms.size = CGSizeMake(5, 5);
    
    [hintLayer addGraphic:[AGSGraphic graphicWithGeometry:mappoint symbol:sms attributes:nil]];
    [pointsArray addObject:mappoint];
    
    [graphicLayer removeAllGraphics];
    
    AGSPolygon *polygon = [TYGeometryFactory convexHullFromPoints:pointsArray];
    if (polygon != nil) {
        AGSSimpleFillSymbol *sfs = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:0.5] outlineColor:[UIColor redColor]];
        [graphicLayer addGraphic:[AGSGraphic graphicWithGeometry:polygon symbol:sfs attributes:nil]];
    } else {
        NSLog(@"Point number less than 3");
    }
}

- (IBAction)buttonClicked:(id)sender {
    [pointsArray removeAllObjects];
    [hintLayer removeAllGraphics];
}
@end
