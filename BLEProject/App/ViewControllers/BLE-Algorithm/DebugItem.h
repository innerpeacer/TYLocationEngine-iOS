//
//  DebugItem.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/4.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IP_DEBUG_ITEM_PUBLIC_BEACON @"PublicBeacon"
#define IP_DEBUG_ITEM_BEACON_SIGNAL @"BeaconSignal"
#define IP_DEBUG_ITEM_START_TRACE @"StartTrace"
#define IP_DEBUG_ITEM_SAVE_TRACE @"SaveTrace"
#define IP_DEBUG_ITEM_SHOW_TRACE @"ShowTrace"

#define IP_DEBUG_ITEM_START_RAW_DATA @"StartRawData"
#define IP_DEBUG_ITEM_SAVE_RAW_DATA @"SaveRawData"

#define IP_DEBUG_ITEM_START_REPLAY @"StartReplay"


@interface DebugItem : NSObject

@property (nonatomic, strong) NSString *itemID;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nameOff;

@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) BOOL on;

- (void)switchStatus;

+ (DebugItem *)itemWithID:(NSString *)itemID;
+ (DebugItem *)itemWithID:(NSString *)itemID Name:(NSString *)name SEL:(SEL)sel;
@end
