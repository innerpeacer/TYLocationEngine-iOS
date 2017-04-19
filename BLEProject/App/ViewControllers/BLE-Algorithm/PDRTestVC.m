//
//  PDRTestVC.m
//  BLEProject
//
//  Created by innerpeacer on 2017/4/19.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "PDRTestVC.h"

@interface PDRTestVC ()

@property (weak, nonatomic) IBOutlet UISwitch *publicSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *followingModeSwitch;

- (IBAction)publicSwitchToggled:(id)sender;
- (IBAction)followingModeSwitchToggled:(id)sender;
@end

@implementation PDRTestVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)publicSwitchToggled:(id)sender {
    if (self.publicSwitch.on) {
        
    } else {

    }
}

- (IBAction)followingModeSwitchToggled:(id)sender {
    if (self.followingModeSwitch.on) {
        [self.mapView setMapMode:TYMapViewModeFollowing];
    } else {
        [self.mapView setMapMode:TYMapViewModeDefault];
    }
}

@end
