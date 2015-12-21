#import "FloorMapVC.h"
#import <TYMapSDK/TYMapSDK.h>

#import "LicenseManager.h"

@interface FloorMapVC ()
{
    NSArray *allMapInfos;
    TYMapInfo *currentMapInfo;
    
    int currentIndex;
    
    AGSGraphicsLayer *hintLayer;
}

@end

@implementation FloorMapVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    allMapInfos = [[NSArray alloc] init];
    if (self.currentBuilding) {
        allMapInfos = [TYMapInfo parseAllMapInfo:self.currentBuilding];
    }
    
    NSLog(@"%@", self.currentBuilding);
    NSLog(@"%@", allMapInfos);
    
    if (allMapInfos.count == 1) {
        currentIndex = 0;
        currentMapInfo = [allMapInfos objectAtIndex:0];
        
        [self initMap];
        
        self.title = currentMapInfo.floorName;
    }
    
    if (allMapInfos.count > 1) {
        
        currentIndex = 0;
        currentMapInfo = [allMapInfos objectAtIndex:0];
        
        for (int i = 0; i < allMapInfos.count; ++i) {
            TYMapInfo *info = [allMapInfos objectAtIndex:i];
            if ([info.floorName isEqualToString:@"F1"]) {
                currentIndex = i;
                currentMapInfo = info;
                break;
            }
        }
        
        [self initFloorSegment];
        [self initMap];
        
        self.title = currentMapInfo.floorName;
    }
    
    self.mapView.rotationAngle = self.currentBuilding.initAngle;
}


- (void)initMap
{
    NSDictionary *dict = [LicenseManager getLicenseForBuilding:_currentBuilding.buildingID];
    
    [self.mapView initMapViewWithBuilding:_currentBuilding UserID:dict[@"UserID"] License:dict[@"License"]];
    self.mapView.mapDelegate = self;

    [self.mapView setAllowRotationByPinching:YES];
    
    self.mapView.highlightPOIOnSelection = YES;
    
    self.mapView.backgroundColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:136/255.0];
    self.mapView.gridLineWidth = 0.0;
    
    [self.mapView setFloorWithInfo:currentMapInfo];
    
    hintLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:hintLayer];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToZooming:) name:@"AGSMapViewDidEndZoomingNotification" object:nil];
}

- (void)initFloorSegment
{
    NSMutableArray *floorNameArray = [[NSMutableArray alloc] init];
    for (TYMapInfo *mapInfo in allMapInfos) {
        [floorNameArray addObject:mapInfo.floorName];
    }
    
    UISegmentedControl *floorSegment = [[UISegmentedControl alloc] initWithItems:floorNameArray];
    floorSegment.frame = CGRectMake(20.0, 80.0, 280.0, 30.0);

    floorSegment.tintColor = [UIColor blueColor];
    floorSegment.selectedSegmentIndex = currentIndex;
    
    [floorSegment addTarget:self action:@selector(floorChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:floorSegment];
}

- (IBAction)floorChanged:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    currentIndex = (int)control.selectedSegmentIndex;
    currentMapInfo = [allMapInfos objectAtIndex:currentIndex];
    self.title = currentMapInfo.floorName;
    [self.mapView setFloorWithInfo:currentMapInfo];
}

- (void)viewDidUnload
{
    self.mapView = nil;
}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
{
//    NSLog(@"%f, %f", mappoint.x, mappoint.y);
    NSLog(@"CurrentAngle: %f", self.mapView.rotationAngle);
    self.mapView.rotationAngle = self.mapView.rotationAngle + 1;
}

- (void)TYMapView:(TYMapView *)mapView PoiSelected:(NSArray *)array
{
    
}

- (void)TYMapView:(TYMapView *)mapView didFinishLoadingFloor:(TYMapInfo *)mapInfo
{
    
}

- (void)mapViewDidLoad:(AGSMapView *)mapView
{
    
}

- (void)respondToZooming:(NSNotification *)notification
{

}


@end
