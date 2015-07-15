#import <UIKit/UIKit.h>
#import <TYMapSDK/TYMapSDK.h>

@interface FloorMapVC : UIViewController<AGSMapViewLayerDelegate, TYMapViewDelegate>

@property (weak, nonatomic) IBOutlet TYMapView *mapView;
@property (strong, nonatomic) TYBuilding *currentBuilding;

@end
