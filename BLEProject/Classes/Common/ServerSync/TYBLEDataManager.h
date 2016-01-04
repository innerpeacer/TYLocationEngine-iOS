//
//  TYBLEDataManager.h
//  BLEProject
//
//  Created by innerpeacer on 16/1/4.
//  Copyright © 2016年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TYBLEDataManager;

@protocol TYBLEDataManagerDelegate <NSObject>

- (void)TYBLEDataManagerDidFinishFetchingData:(TYBLEDataManager *)manager;
- (void)TYBLEDataManagerDidFailedFetchingData:(TYBLEDataManager *)manager WithError:(NSError *)error;

@end

@interface TYBLEDataManager : NSObject

@property (nonatomic, weak) id<TYBLEDataManagerDelegate> delegate;

- (id)initWithUserID:(NSString *)userID Building:(TYBuilding *)building License:(NSString *)license;
- (void)fetchLocatingData;

@end
