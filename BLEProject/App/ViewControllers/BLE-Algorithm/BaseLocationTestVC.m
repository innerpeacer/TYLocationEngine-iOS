//
//  BaseLocationTestVC.m
//  BLEProject
//
//  Created by innerpeacer on 2017/4/30.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "BaseLocationTestVC.h"

@interface BaseLocationTestVC ()

@end

@implementation BaseLocationTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signalLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.signalLayer];
    
    self.publicBeaconLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.publicBeaconLayer];

    self.locationLayer1 = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.locationLayer1];
    
    self.locationLayer2 = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.locationLayer2];
    
    self.locationSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"l7"];
    self.locationArrowSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"locationArrow2"];
    self.locationArrowSymbol.size = CGSizeMake(60, 60);

//    [self.mapView setLocationSymbol:self.locationSymbol];
    [self.mapView setLocationSymbol:self.locationArrowSymbol];
}

- (IBAction)publicSwitchToggled:(id)sender {
    if (self.publicSwitch.on) {
        [LocationTestHelper showBeaconLocationsWithMapInfo:self.currentMapInfo Building:self.currentBuilding OnLayer:self.publicBeaconLayer];
    } else {
        [self.publicBeaconLayer removeAllGraphics];
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
