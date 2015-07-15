#import "AddPrimitiveBeaconsVC.h"
#import "TYBeacon.h"
#import "TYPrimitiveBeaconDBAdapter.h"
#import "ShowPrimitiveBeaconTableVC.h"
#import "TYUserDefaults.h"

@interface AddPrimitiveBeaconsVC ()
{
    NSArray *titleArray;
    NSArray *numArray;

    TYBuilding *currentBuilding;
}

@end

@implementation AddPrimitiveBeaconsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentBuilding = [TYUserDefaults getDefaultBuilding];
}

- (IBAction)addBeaconClicked:(id)sender {

    NSString *majorString = self.majorField.text;
    NSString *minorString = self.minorField.text;
    NSString *tagString = self.tagField.text;

    if (majorString != nil && minorString != nil && tagString != nil) {

        if ([self validateValue:majorString] && [self validateValue:minorString] && tagString.length > 0) {
            NSNumber *major = [NSNumber numberWithInt:majorString.intValue];
            NSNumber *minor = [NSNumber numberWithInt:minorString.intValue];

            TYPrimitiveBeaconDBAdapter *db = [[TYPrimitiveBeaconDBAdapter alloc] initWithBuilding:currentBuilding];
            [db open];

            BOOL success = false;
            TYBeacon *beacon = [db getPrimitiveBeaconWithMajor:major Minor:minor];
            if (beacon == nil) {
                success = [db insertPrimitiveBeaconWithMajor:major Minor:minor Tag:tagString];
            } else {
                success = [db updatePrimitiveBeaconWithMajor:major Minor:minor Tag:tagString];
            }

            [db close];

            if (success) {
                if (beacon) {
                    self.title = @"Update Success!";
                } else {
                    self.title = @"Insert Success!";
                }
            } else {
                self.title = @"Insert or Update Failed";
            }

        }

    }
}

- (IBAction)showBeaconsClicked:(id)sender
{
    NSString *identifier = @"showPrimitiveBeaconController";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BLE-Tool" bundle:nil];

    ShowPrimitiveBeaconTableVC *controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];

    [self presentViewController:naviController animated:YES completion:nil];
}


- (BOOL)validateValue:(NSString *)value
{
    NSString *strRegex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [pred evaluateWithObject:value];
}

- (IBAction)helpButtonClicked:(id)sender {
    
    if (self.tagField.isFirstResponder) {
        [self.tagField resignFirstResponder];
    }
    if (self.majorField.isFirstResponder) {
        [self.majorField resignFirstResponder];
    }
    if (self.minorField.isFirstResponder) {
        [self.minorField resignFirstResponder];
    }
}
@end
