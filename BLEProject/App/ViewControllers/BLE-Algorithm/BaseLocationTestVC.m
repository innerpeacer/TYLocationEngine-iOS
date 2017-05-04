//
//  BaseLocationTestVC.m
//  BLEProject
//
//  Created by innerpeacer on 2017/4/30.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "BaseLocationTestVC.h"

@interface BaseLocationTestVC () <UIActionSheetDelegate>

@end

@implementation BaseLocationTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.debugItems = [[NSMutableArray alloc] init];
    [self.debugItems addObject:[DebugItem itemWithID:IP_DEBUG_ITEM_PUBLIC_BEACON]];
    
    self.signalLayer = [ArcGISHelper createNewLayer:self.mapView];
    self.publicBeaconLayer = [ArcGISHelper createNewLayer:self.mapView];
    self.traceLayer = [ArcGISHelper createNewLayer:self.mapView];
    self.locationLayer1 = [ArcGISHelper createNewLayer:self.mapView];
    self.locationLayer2 = [ArcGISHelper createNewLayer:self.mapView];
    
    self.locationSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"l7"];
    self.locationArrowSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"locationArrow2"];
    self.locationArrowSymbol.size = CGSizeMake(60, 60);

//    [self.mapView setLocationSymbol:self.locationSymbol];
    [self.mapView setLocationSymbol:self.locationArrowSymbol];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"调试" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemTest:)];
}

- (IBAction)rightBarButtonItemTest:(id)sender
{
    BRTLog(@"rightBarButtonItemTest");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"调试内容" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    for (DebugItem *item in self.debugItems) {
        [actionSheet addButtonWithTitle:(item.on ? item.nameOff : item.name)];
    }
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BRTLog(@"clickedButtonAtIndex: %d", (int)buttonIndex);
    if (buttonIndex == 0) {
        return;
    }
    DebugItem *item = self.debugItems[buttonIndex - 1];
    [item switchStatus];
    [self performSelector:item.selector withObject:item afterDelay:0];
}

- (void)switchPublicBeacon:(id)sender
{
    BRTLog(@"switchPublicBeacon");
    DebugItem *item = sender;
    if (item.on) {
        [LocationTestHelper showBeaconLocationsWithMapInfo:self.currentMapInfo Building:self.currentBuilding OnLayer:self.publicBeaconLayer];
    } else {
        [self.publicBeaconLayer removeAllGraphics];
    }
}

- (void)switchBeaconSignal:(id)sender
{
    BRTLog(@"switchPublicBeacon");
    DebugItem *item = sender;
    self.isSignalOn = item.on;
}

@end
