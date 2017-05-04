//
//  BaseLocationTestVC.h
//  BLEProject
//
//  Created by innerpeacer on 2017/4/30.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "BaseMapVC.h"

@interface BaseLocationTestVC : BaseMapVC

@property (nonatomic, strong) AGSGraphicsLayer *publicBeaconLayer;
@property (nonatomic, strong) AGSGraphicsLayer *signalLayer;

@property (nonatomic, strong) AGSGraphicsLayer *locationLayer1;
@property (nonatomic, strong) AGSGraphicsLayer *locationLayer2;

@property (nonatomic, strong) AGSPictureMarkerSymbol *locationSymbol;
@property (nonatomic, strong) AGSPictureMarkerSymbol *locationArrowSymbol;

@property (weak, nonatomic) IBOutlet UISwitch *publicSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *followingModeSwitch;

- (IBAction)publicSwitchToggled:(id)sender;
- (IBAction)followingModeSwitchToggled:(id)sender;

@end
