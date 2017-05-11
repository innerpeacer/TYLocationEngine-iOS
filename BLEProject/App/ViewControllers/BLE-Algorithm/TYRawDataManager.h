//
//  TYRawDataManager.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/10.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYRawDataCollection.h"

@interface TYRawDataManager : NSObject

+ (TYRawDataCollection *)currentData;
+ (void)setCurrentData:(TYRawDataCollection *)data;

+ (TYRawDataCollection *)createNewData;

+ (void)saveData:(TYRawDataCollection *)data;
+ (void)deleteData:(NSString *)dataID;
+ (void)deleteAllData;
+ (TYRawDataCollection *)getData:(NSString *)dataID;

+ (NSArray *)getAllDataID;
+ (NSArray *)getAllData;

@end
