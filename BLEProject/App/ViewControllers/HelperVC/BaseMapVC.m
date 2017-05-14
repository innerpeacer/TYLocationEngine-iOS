#import "BaseMapVC.h"
#import <UIKit/UIKit.h>

#import "TYUserDefaults.h"

#import <TYMapSDK/TYMapSDK.h>
#import "MapLicenseGenerator.h"
@interface BaseMapVC() <UIActionSheetDelegate>
{
    int currentIndex;
}

@end

@implementation BaseMapVC

#define FILE_MAPINFO @"MapInfo_Building"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentCity = [TYUserDefaults getDefaultCity];
    _currentBuilding = [TYUserDefaults getDefaultBuilding];
    
    _allMapInfos = [TYMapInfo parseAllMapInfo:_currentBuilding];
    
    if (_allMapInfos.count == 1) {
        currentIndex = 0;
        _currentMapInfo = [_allMapInfos objectAtIndex:0];
        
        [self initMap];
        self.title = _currentMapInfo.floorName;
    }
    
    if (_allMapInfos.count > 1) {
        
        currentIndex = 0;
        _currentMapInfo = [_allMapInfos objectAtIndex:0];
        
        for (int i = 0; i < _allMapInfos.count; ++i) {
            TYMapInfo *info = [_allMapInfos objectAtIndex:i];
            if ([info.floorName isEqualToString:@"F1"]) {
                currentIndex = i;
                _currentMapInfo = info;
                break;
            }
        }
        
        [self initFloorSegment];
        [self initMap];
        self.title = _currentMapInfo.floorName;
    }
    
    
    self.publicBeaconLayer = [ArcGISHelper createNewLayer:self.mapView];
    self.traceLayer1 = [ArcGISHelper createNewLayer:self.mapView];
    self.traceLayer2 = [ArcGISHelper createNewLayer:self.mapView];
    self.signalLayer = [ArcGISHelper createNewLayer:self.mapView];
    
    self.locationLayer1 = [ArcGISHelper createNewLayer:self.mapView];
    self.locationLayer2 = [ArcGISHelper createNewLayer:self.mapView];
    self.hintLayer = [ArcGISHelper createNewLayer:self.mapView];
    
    self.locationSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"l7"];
    self.locationArrowSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"locationArrow2"];
    self.locationArrowSymbol.size = CGSizeMake(60, 60);
    
    //    [self.mapView setLocationSymbol:self.locationSymbol];
    [self.mapView setLocationSymbol:self.locationArrowSymbol];
    
    NSString *title = [NSString stringWithFormat:@"%@调试", (self.name == nil ? @"" : self.name)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemTest:)];
    
    self.debugItems = [[NSMutableArray alloc] init];
    
}

- (IBAction)rightBarButtonItemTest:(id)sender
{
    //    BRTLog(@"rightBarButtonItemTest");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"调试内容" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    for (DebugItem *item in self.debugItems) {
        [actionSheet addButtonWithTitle:(item.on ? item.nameOff : item.name)];
    }
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    BRTLog(@"clickedButtonAtIndex: %d", (int)buttonIndex);
    if (buttonIndex == 0) {
        return;
    }
    DebugItem *item = self.debugItems[buttonIndex - 1];
    [item switchStatus];
    [self performSelector:item.selector withObject:item afterDelay:0];
}

- (void)initFloorSegment
{
    NSMutableArray *floorNameArray = [[NSMutableArray alloc] init];
    for (TYMapInfo *mapInfo in _allMapInfos) {
        [floorNameArray addObject:mapInfo.floorName];
    }
    
    _floorSegment = [[UISegmentedControl alloc] initWithItems:floorNameArray];
    
    double screenWidth = self.view.frame.size.width;
    double xOffset = 20;
    double yOffset = 80;
    double height = 30;
    _floorSegment.frame = CGRectMake(xOffset, yOffset, screenWidth - xOffset * 2, height);
    _floorSegment.tintColor = [UIColor blueColor];
    _floorSegment.selectedSegmentIndex = currentIndex;
    
    
    [_floorSegment addTarget:self action:@selector(floorChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_floorSegment];
}

- (IBAction)floorChanged:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    currentIndex = (int)control.selectedSegmentIndex;
    _currentMapInfo = [_allMapInfos objectAtIndex:currentIndex];
    self.title = _currentMapInfo.floorName;
    [self.mapView setFloorWithInfo:_currentMapInfo];
}

- (void)initMap
{
//    NSDictionary *dict = [LicenseManager getLicenseForBuilding:_currentBuilding.buildingID];
//    NSLog(@"%@", dict);
//    NSLog(@"%d", (int)[dict[@"License"] length]);
//    
//    [self.mapView initMapViewWithBuilding:_currentBuilding UserID:dict[@"UserID"] License:dict[@"License"]];
        [self.mapView initMapViewWithBuilding:_currentBuilding UserID:TRIAL_USER_ID License:[MapLicenseGenerator generateBase64License40ForUserID:TRIAL_USER_ID Building:_currentBuilding.buildingID ExpiredDate:TRIAL_EXPRIED_DATE]];
    self.mapView.mapDelegate = self;

    self.mapView.backgroundColor = [UIColor lightGrayColor];
    self.mapView.gridLineWidth = 0.0;
    
//    self.mapView.highlightPOIOnSelection = YES;
    [self.mapView setFloorWithInfo:_currentMapInfo];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToZooming:) name:@"AGSMapViewDidEndZoomingNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToPanning:) name:@"AGSMapViewDidEndPanningNotification" object:nil];
}

- (void)viewDidUnload
{
    self.mapView = nil;
}

- (void)TYMapView:(TYMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint
{
//    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)TYMapView:(TYMapView *)mapView PoiSelected:(NSArray *)array
{
//    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)TYMapView:(TYMapView *)mapView didFinishLoadingFloor:(TYMapInfo *)mapInfo
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)mapViewDidLoad:(AGSMapView *)mapView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)respondToZooming:(NSNotification *)notification
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)respondToPanning:(NSNotification *)notification
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


@end
