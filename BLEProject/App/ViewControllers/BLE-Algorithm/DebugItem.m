//
//  DebugItem.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/4.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "DebugItem.h"

//static NSArray *debugItemTestArrays = @[
//@[@"", @"", @"", @""]
//                                        
//                                        ];

@implementation DebugItem

+ (DebugItem *)itemWithID:(NSString *)itemID
{
    static NSArray *testItems;
    if (testItems == nil) {
        testItems = @[
                      @[IP_DEBUG_ITEM_PUBLIC_BEACON, @"显示点位", @"隐藏点位", @(YES), @"switchPublicBeacon:"],
                      @[IP_DEBUG_ITEM_BEACON_SIGNAL, @"显示信号", @"隐藏信号", @(YES), @"switchBeaconSignal:"],
                      @[IP_DEBUG_ITEM_SAVE_TRACE, @"保存轨迹", @"保存轨迹", @(YES), @"saveTrace:"],
                      @[IP_DEBUG_ITEM_SHOW_TRACE, @"显示轨迹", @"显示轨迹", @(YES), @"showTrace:"]
                      ];
    }
    
    static NSMutableDictionary *itemDict;
    if (itemDict == nil) {
        itemDict = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < testItems.count; ++i) {
            NSArray *array = testItems[i];
            DebugItem *item = [[DebugItem alloc] init];
            item.itemID = array[0];
            item.name = array[1];
            item.nameOff = array[2];
            item.on = [array[3] boolValue];
            item.selector = NSSelectorFromString(array[4]);
            
            [itemDict setObject:item forKey:item.itemID];
        }
    }
    return itemDict[itemID];
}

+ (DebugItem *)itemWithID:(NSString *)itemID Name:(NSString *)name SEL:(SEL)sel
{
    DebugItem *item = [[DebugItem alloc] init];
    item.itemID = itemID;
    item.name = name;
    item.selector = sel;
    item.on = NO;
    return item;
}

- (void)switchStatus
{
    self.on = !self.on;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", _name];
}

@end
