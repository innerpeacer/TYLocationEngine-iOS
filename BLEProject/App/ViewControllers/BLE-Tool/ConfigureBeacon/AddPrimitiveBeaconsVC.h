#import <UIKit/UIKit.h>

@interface AddPrimitiveBeaconsVC : UIViewController<UITextFieldDelegate>

- (IBAction)addBeaconClicked:(id)sender;
- (IBAction)showBeaconsClicked:(id)sender;
- (IBAction)helpButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UITextField *majorField;
@property (weak, nonatomic) IBOutlet UITextField *minorField;
@property (weak, nonatomic) IBOutlet UITextField *tagField;

@end