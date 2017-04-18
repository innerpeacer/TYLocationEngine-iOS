#import <UIKit/UIKit.h>
#import "ControllerObject.h"

@interface BaseControllerTableVC : UITableViewController
@property (nonatomic, strong) NSArray *controllerObjects;
@property (nonatomic, strong) NSString *storyboardName;
@end

@interface BLEAlgorithmTableVC : BaseControllerTableVC
@end

@interface BLEToolTableVC : BaseControllerTableVC
@end

@interface MapTableVC : BaseControllerTableVC
@end
