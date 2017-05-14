#import <Foundation/Foundation.h>
#import <TYMapSDK/TYMapSDK.h>
#import "LocationTestHelper.h"
#import "ArcGISHelper.h"
#import "DebugItem.h"

@interface BaseMapVC : UIViewController <TYMapViewDelegate, AGSMapViewLayerDelegate>

@property (weak, nonatomic) IBOutlet TYMapView *mapView;
@property (strong, nonatomic) TYMapInfo *currentMapInfo;
@property (strong, nonatomic) TYCity *currentCity;
@property (strong, nonatomic) TYBuilding *currentBuilding;
@property (strong, nonatomic) NSArray *allMapInfos;

@property (strong, nonatomic) UISegmentedControl *floorSegment;


@property (nonatomic, strong) AGSGraphicsLayer *publicBeaconLayer;
@property (nonatomic, strong) AGSGraphicsLayer *signalLayer;

@property (nonatomic, strong) AGSGraphicsLayer *traceLayer1;
@property (nonatomic, strong) AGSGraphicsLayer *traceLayer2;

@property (nonatomic, strong) AGSGraphicsLayer *locationLayer1;
@property (nonatomic, strong) AGSGraphicsLayer *locationLayer2;

@property (nonatomic, strong) AGSGraphicsLayer *hintLayer;

@property (nonatomic, strong) AGSPictureMarkerSymbol *locationSymbol;
@property (nonatomic, strong) AGSPictureMarkerSymbol *locationArrowSymbol;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *debugItems;


- (IBAction)floorChanged:(id)sender;

@end
