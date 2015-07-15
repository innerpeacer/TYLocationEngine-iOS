#import <UIKit/UIKit.h>

@interface SetCurrentPlaceVC : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *cityPickerView;

- (IBAction)chooseBuilding:(id)sender;
- (IBAction)cancel:(id)sender;
@end
