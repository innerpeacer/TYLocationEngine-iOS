//
//  TYTrace+Protobuf.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/5.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TYTrace+Protobuf.h"
#import "TYTracePbf.pbobjc.h"

@implementation TYTracePoint(Protobuf)

- (TYTracePointPbf *)toPbf
{
    TYTracePointPbf *pbf = [[TYTracePointPbf alloc] init];
    pbf.x = self.x;
    pbf.y = self.y;
    pbf.floor = self.floor;
    pbf.index = self.index;
    pbf.timestamp = self.timestamp;
    return pbf;
}

- (NSData *)data
{
    return [[self toPbf] data];
}


- (id)initWithTracePointPbf:(TYTracePointPbf *)pbf
{
    return [[[self class] alloc] initWithX:pbf.x Y:pbf.y Floor:pbf.floor Index:pbf.index Timestamp:pbf.timestamp];
}

+ (TYTracePoint *)tracePointWithData:(NSData *)data error:(NSError *)err
{
    TYTracePointPbf *pbf = [[TYTracePointPbf alloc] initWithData:data error:&err];
    if (err) {
        NSLog(@"Error: %@", err.localizedDescription);
        return nil;
    }
    return [[TYTracePoint alloc] initWithTracePointPbf:pbf];
}

@end

@implementation TYTrace(Protobuf)

- (TYTracePbf *)toPbf
{
    TYTracePbf *pbf = [[TYTracePbf alloc] init];
    pbf.traceId = self.traceID;
    pbf.timestamp = self.timestamp;
    pbf.pointsArray = [NSMutableArray arrayWithCapacity:self.points.count];
    for (int i = 0; i < self.points.count; ++i) {
        TYTracePoint *tp = self.points[i];
        pbf.pointsArray[i] = [tp toPbf];
    }
    return pbf;
}

- (NSData *)data
{
    return [[self toPbf] data];
}

- (id)initWithTracePbf:(TYTracePbf *)pbf
{
    NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:pbf.pointsArray.count];
    for (int i = 0; i < pbf.pointsArray.count; ++i) {
        pointArray[i] = [[TYTracePoint alloc] initWithTracePointPbf:pbf.pointsArray[i]];
    }
    return [[[self class] alloc] initWithTraceID:pbf.traceId Timestamp:pbf.timestamp Points:pointArray];
}

+ (TYTrace *)traceWithData:(NSData *)data error:(NSError *)err
{
    TYTracePbf *pbf = [[TYTracePbf alloc] initWithData:data error:&err];
    if (err) {
        NSLog(@"Error: %@", err.localizedDescription);
        return nil;
    }
    return [[TYTrace alloc] initWithTracePbf:pbf];
}

@end
