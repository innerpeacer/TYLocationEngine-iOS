//
//  TYFanRange.h
//  BLEProject
//
//  Created by innerpeacer on 2017/5/15.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

typedef enum {
    IP_Contain,
    IP_Forward,
    IP_Backward,
    IP_Unknown
} LocationRangeStatus;

@interface TYFanRange : NSObject
//@property (nonatomic, strong) NSNumber *heading;
@property (nonatomic, strong) TYLocalPoint *center;

- (id)initWithCenter:(TYLocalPoint *)center Heading:(NSNumber *)heading;
- (void)updateCenter:(TYLocalPoint *)center;
- (void)updateHeading:(double)heading;

- (BOOL)containPoint:(TYLocalPoint *)lp;
- (LocationRangeStatus)getStatus:(TYLocalPoint *)lp;
- (AGSGeometry *)toFanGeometry;

@end
