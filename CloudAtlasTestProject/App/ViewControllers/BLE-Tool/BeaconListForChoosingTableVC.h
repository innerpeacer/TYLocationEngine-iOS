#import <UIKit/UIKit.h>
#import "NPBeacon.h"

@protocol BeaconSelectedDelegate <NSObject>

- (void)didSelectBeacon:(NPBeacon *)beacon;

@end

@interface BeaconListForChoosingTableVC : UITableViewController

@property (weak, nonatomic) id<BeaconSelectedDelegate> delegate;

@end
