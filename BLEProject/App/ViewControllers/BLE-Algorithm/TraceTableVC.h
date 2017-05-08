//
//  TraceTableVC.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/8.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TraceTableNaviController : UINavigationController
@property (nonatomic, weak) UIViewController *startingController;
@end

@interface TraceTableVC : UITableViewController
@property (nonatomic, weak) UIViewController *startingController;
@end
