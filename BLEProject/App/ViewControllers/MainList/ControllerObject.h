//
//  ControllerObject.h
//  BLEProject
//
//  Created by innerpeacer on 2017/4/18.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControllerObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *storyboardID;

@end

@interface ControllerCollections : NSObject

+ (NSArray *)bleToolControllers;
+ (NSArray *)bleAlgorithmControllers;
+ (NSArray *)mapControllers;

@end
