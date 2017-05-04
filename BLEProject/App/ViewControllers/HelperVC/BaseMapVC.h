#import <Foundation/Foundation.h>
#import <TYMapSDK/TYMapSDK.h>
#import "LocationTestHelper.h"

@interface BaseMapVC : UIViewController <TYMapViewDelegate, AGSMapViewLayerDelegate>

@property (weak, nonatomic) IBOutlet TYMapView *mapView;
@property (strong, nonatomic) TYMapInfo *currentMapInfo;
@property (strong, nonatomic) TYCity *currentCity;
@property (strong, nonatomic) TYBuilding *currentBuilding;
@property (strong, nonatomic) NSArray *allMapInfos;

@property (strong, nonatomic) UISegmentedControl *floorSegment;

- (IBAction)floorChanged:(id)sender;

@end
