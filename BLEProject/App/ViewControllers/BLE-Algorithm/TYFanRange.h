//
//  TYFanRange.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/15.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@interface TYFanRange : NSObject
@property (nonatomic, assign) double heading;
@property (nonatomic, strong) TYLocalPoint *center;

- (id)initWithCenter:(TYLocalPoint *)center Heading:(double)heading;
- (AGSGeometry *)toFanGeometry;

@end
