#import <UIKit/UIKit.h>
#import "TYBeacon.h"

@protocol BeaconSelectedDelegate <NSObject>

- (void)didSelectBeacon:(TYBeacon *)beacon;

@end

@interface BeaconListForChoosingTableVC : UITableViewController

@property (weak, nonatomic) id<BeaconSelectedDelegate> delegate;

@end
