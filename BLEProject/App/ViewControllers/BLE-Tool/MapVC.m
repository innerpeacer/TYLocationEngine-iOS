#import "MapVC.h"

#import <TYMapSDK/TYMapSDK.h>

#import "TYGeometryFactory.h"
#import "TYVector2.h"

#import "TYVector2D.h"
#import "TYVectorLine.h"

@interface MapVC()
{
    AGSGraphicsLayer *hintLayer;
    AGSGraphicsLayer *graphicLayer;
    
    NSMutableArray *pointsArray;
    
}

- (IBAction)buttonClicked:(id)sender;
@end

@implementation MapVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    hintLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:hintLayer];
    
    graphicLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:graphicLayer];
    
    pointsArray = [[NSMutableArray alloc] init];
}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
{
    NSLog(@"%f, %f", mappoint.x, mappoint.y);
    
    AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor greenColor]];
    sms.size = CGSizeMake(5, 5);
    
    [hintLayer removeAllGraphics];
    [hintLayer addGraphic:[AGSGraphic graphicWithGeometry:mappoint symbol:sms attributes:nil]];
    if (pointsArray.count < 3) {
        [pointsArray addObject:mappoint];
    } else {
        pointsArray[2] = mappoint;
    }
    
    
    [self testVector];
}

- (void)testVector
{
    if (pointsArray.count != 3) {
        return;
    }
    
    BRTLog(@"Test");
    [graphicLayer removeAllGraphics];
    AGSSimpleLineSymbol *sls = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor redColor] width:2.0f];
    TYVectorLine *signalLine = [[TYVectorLine alloc] initWithP1:[self fromAgsPoint:pointsArray[0]] P2:[self fromAgsPoint:pointsArray[1]]];
    
    AGSSimpleLineSymbol *sls2 = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor yellowColor] width:2.0f];
    TYVectorLine *targetLine = [[TYVectorLine alloc] initWithP1:[self fromAgsPoint:pointsArray[0]] P2:[self fromAgsPoint:pointsArray[2]]];
    
    AGSSimpleLineSymbol *sls3 = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor blueColor] width:4.0f];
    TYVectorLine *snappedLine = [signalLine projectOfVectorLine:targetLine];
    
    [graphicLayer addGraphic:[AGSGraphic graphicWithGeometry:[signalLine toGeometry] symbol:sls attributes:nil]];
    [graphicLayer addGraphic:[AGSGraphic graphicWithGeometry:[targetLine toGeometry] symbol:sls2 attributes:nil]];
    [graphicLayer addGraphic:[AGSGraphic graphicWithGeometry:[snappedLine  toGeometry] symbol:sls3 attributes:nil]];

}

- (TYLocalPoint *)fromAgsPoint:(AGSPoint *)point
{
    return [TYLocalPoint pointWithX:point.x Y:point.y];
}

- (IBAction)buttonClicked:(id)sender {
    [pointsArray removeAllObjects];
    [hintLayer removeAllGraphics];
}
@end
