//
//  TYLTSTriangulationAlgorithm.m
//  BLEProject
//
//  Created by innerpeacer on 15/1/29.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#import "TYTriangulationAlgorithm.h"
#import <CoreLocation/CoreLocation.h>
#import "TYPublicBeacon.h"
#import "BLELocationEngineConstants.h"

#define DEFAULT_NUM_FOR_TRIANGULATION 4


@interface TYTriangulationAlgorithm()
{
    
}
- (TYLocalPoint *)singleTriangulationForB1:(CLBeacon *)b1 B2:(CLBeacon *)b2 B3:(CLBeacon *)b3;
- (TYLocalPoint *)trippleTriangulationForB1:(CLBeacon *)b1 B2:(CLBeacon *)b2 B3:(CLBeacon *)b3;
- (TYLocalPoint *)calculateBeaconLessThanThree;
- (TYLocalPoint *)calculateOneBeacon:(CLBeacon *)b;
- (TYLocalPoint *)calculateTwoBeaconsForB1:(CLBeacon *)b1 B2:(CLBeacon *)b2;
- (TYLocalPoint *)localpointForP1:(TYLocalPoint *)p1 Accuracy1:(double)a1 P2:(TYLocalPoint *)p2 Accuracy2:(double)a2;

@end

@interface TYSingleTriangulationAlgorithm : TYTriangulationAlgorithm

@end

@interface TYTrippleTriangulationAlgorithm : TYTriangulationAlgorithm

@end

@interface TYHybridSingleTriangulationAlgorithm : TYTriangulationAlgorithm

@end

@interface TYHybridTrippleTriangulationAlgorithm : TYTriangulationAlgorithm

@end


@implementation TYTriangulationAlgorithm

- (id)initWithBeaconDictionary:(NSDictionary *)dict
{
    self = [super initWithBeaconDictionary:dict];
    if (self) {
        
    }
    return self;
}

+ (TYTriangulationAlgorithm *)algorithmWithBeaconDictionary:(NSDictionary *)dict Type:(AlgorithmType)type
{
    switch (type) {
        case Single:
            return [[TYSingleTriangulationAlgorithm alloc] initWithBeaconDictionary:dict];
            break;
            
        case Tripple:
            return [[TYTrippleTriangulationAlgorithm alloc] initWithBeaconDictionary:dict];
            break;
            
        case HybridSingle:
            return [[TYHybridSingleTriangulationAlgorithm alloc] initWithBeaconDictionary:dict];
            break;
            
        case HybridTriple:
            return [[TYHybridTrippleTriangulationAlgorithm alloc] initWithBeaconDictionary:dict];
            break;
            
        default:
            return [[TYSingleTriangulationAlgorithm alloc] initWithBeaconDictionary:dict];
            break;
    }
}

- (TYLocalPoint *)singleTriangulationForB1:(CLBeacon *)b1 B2:(CLBeacon *)b2 B3:(CLBeacon *)b3
{
    TYLocalPoint *result = nil;
    
    NSNumber *bkey1 = [TYBeaconKey beaconKeyForCLBeacon:b1];
    NSNumber *bkey2 = [TYBeaconKey beaconKeyForCLBeacon:b2];
    NSNumber *bkey3 = [TYBeaconKey beaconKeyForCLBeacon:b3];
    
    
    TYPublicBeacon *sb1 = [self.beaconDictionary objectForKey:bkey1];
    TYPublicBeacon *sb2 = [self.beaconDictionary objectForKey:bkey2];
    TYPublicBeacon *sb3 = [self.beaconDictionary objectForKey:bkey3];
    
    TYLocalPoint *lp1 = sb1.location;
    TYLocalPoint *lp2 = sb2.location;
    TYLocalPoint *lp3 = sb3.location;
    
    TYLocalPoint *r12 = [self localpointForP1:lp1 Accuracy1:b1.accuracy P2:lp2 Accuracy2:b2.accuracy];
    TYLocalPoint *r13 = [self localpointForP1:lp1 Accuracy1:b1.accuracy P2:lp3 Accuracy2:b3.accuracy];
    result = [self localpointForP1:r12 Accuracy1:b2.accuracy P2:r13 Accuracy2:b3.accuracy];
    result.floor = sb1.location.floor;
    
    return  result;
}

- (TYLocalPoint *)trippleTriangulationForB1:(CLBeacon *)b1 B2:(CLBeacon *)b2 B3:(CLBeacon *)b3
{
    TYLocalPoint *t123 = [self singleTriangulationForB1:b1 B2:b2 B3:b3];
    TYLocalPoint *t231 = [self singleTriangulationForB1:b2 B2:b3 B3:b1];
    TYLocalPoint *t312 = [self singleTriangulationForB1:b3 B2:b1 B3:b2];
    
    double x = (t123.x + t231.x + t312.x)/3.0;
    double y = (t123.y + t231.y + t312.y)/3.0;
    
    TYLocalPoint *result = [TYLocalPoint pointWithX:x Y:y Floor:t123.floor];
    
    return result;
}


- (TYLocalPoint *)calculateBeaconLessThanThree
{
    TYLocalPoint *result = nil;
    
    if (self.nearestBeacons.count == 1) {
        result = [self calculateOneBeacon:[self.nearestBeacons objectAtIndex:0]];
    }
    
    if (self.nearestBeacons.count == 2) {
        result = [self calculateTwoBeaconsForB1:[self.nearestBeacons objectAtIndex:0] B2:[self.nearestBeacons objectAtIndex:1]];
    }
    return result;
}

- (TYLocalPoint *)calculateOneBeacon:(CLBeacon *)b
{
    TYLocalPoint *result = nil;
    
    if (b.proximity == CLProximityImmediate || b.proximity == CLProximityNear) {
        NSNumber *bkey1 = [TYBeaconKey beaconKeyForCLBeacon:b];;
        TYPublicBeacon *pb = [self.beaconDictionary objectForKey:bkey1];
        result = pb.location;
    }
    return result;
}

- (TYLocalPoint *)calculateTwoBeaconsForB1:(CLBeacon *)b1 B2:(CLBeacon *)b2
{
    TYLocalPoint *result = nil;
    
    NSNumber *bkey1 = [TYBeaconKey beaconKeyForCLBeacon:b1];;
    NSNumber *bkey2 = [TYBeaconKey beaconKeyForCLBeacon:b2];;
    
    TYPublicBeacon *sb1 = [self.beaconDictionary objectForKey:bkey1];
    TYPublicBeacon *sb2 = [self.beaconDictionary objectForKey:bkey2];
    
    TYLocalPoint *lp1 = sb1.location;
    TYLocalPoint *lp2 = sb2.location;
    
    result = [self localpointForP1:lp1 Accuracy1:b1.accuracy P2:lp2 Accuracy2:b2.accuracy];
    result.floor = sb1.location.floor;
    
    return result;
}


- (TYLocalPoint *)localpointForP1:(TYLocalPoint *)p1 Accuracy1:(double)a1 P2:(TYLocalPoint *)p2 Accuracy2:(double)a2
{
    double sum = a1 + a2;
    double x = (a1 * p2.x + a2 * p1.x) / sum;
    double y = (a1 * p2.y + a2 * p1.y) / sum;
    return [TYLocalPoint pointWithX:x Y:y];
}

@end

@implementation TYSingleTriangulationAlgorithm

- (TYLocalPoint *)calculationLocation
{
    TYLocalPoint *result = nil;
    
    if (self.nearestBeacons.count < 3) {
        result = [self calculateBeaconLessThanThree];
    }
    
    if (self.nearestBeacons.count >= 3) {
        result = [self singleTriangulationForB1:[self.nearestBeacons objectAtIndex:0] B2:[self.nearestBeacons objectAtIndex:1] B3:[self.nearestBeacons objectAtIndex:2]];
    }
    
    return result;
}

@end



@implementation TYTrippleTriangulationAlgorithm

- (TYLocalPoint *)calculationLocation
{
    TYLocalPoint *result = nil;
    
    if (self.nearestBeacons.count < 3) {
        result = [self calculateBeaconLessThanThree];
    }
    
    if (self.nearestBeacons.count >= 3) {
        result = [self trippleTriangulationForB1:[self.nearestBeacons objectAtIndex:0] B2:[self.nearestBeacons objectAtIndex:1] B3:[self.nearestBeacons objectAtIndex:2]];
    }
    
    return result;
}

@end


@implementation TYHybridSingleTriangulationAlgorithm

- (TYLocalPoint *)calculationLocation
{
    if (self.nearestBeacons.count < 3) {
        return [self calculateBeaconLessThanThree];
    }
    
    CLBeacon *b1 = [self.nearestBeacons objectAtIndex:0];
    CLBeacon *b2 = [self.nearestBeacons objectAtIndex:1];
        
    if (b1.accuracy/b2.accuracy < 0.33) {
        return [self calculateLocationWithAverage3];
    } else {
        return [self calculateLocationWithAverage4];
    }
}


- (TYLocalPoint *)calculateLocationWithAverage4
{
    TYLocalPoint *result = nil;
    
    if (self.nearestBeacons.count < 3) {
        result = [self calculateBeaconLessThanThree];
    }
    
    if (self.nearestBeacons.count >= 3) {
        int count = (int)MIN(DEFAULT_NUM_FOR_TRIANGULATION, self.nearestBeacons.count);
        NSMutableArray *pointList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < count; ++i) {
            for (int j = i + 1; j < count; ++j) {
                for (int k = j + 1; k < count; ++k) {
                    TYLocalPoint *lp = [self singleTriangulationForB1:[self.nearestBeacons objectAtIndex:i] B2:[self.nearestBeacons objectAtIndex:j] B3:[self.nearestBeacons objectAtIndex:k]];
                    [pointList addObject:lp];
                }
            }
        }
        
        double xSum = 0.0;
        double ySum = 0.0;
        int pointCount = (int)pointList.count;
        
        for (TYLocalPoint *lp in pointList) {
            xSum += lp.x;
            ySum += lp.y;
        }
        
        CLBeacon *nb = [self.nearestBeacons objectAtIndex:0];
        NSNumber *bkey = [TYBeaconKey beaconKeyForCLBeacon:nb];;
        TYPublicBeacon *npb = [self.beaconDictionary objectForKey:bkey];
        
        result = [TYLocalPoint pointWithX:xSum/pointCount Y:ySum/pointCount Floor:npb.location.floor];
    }
    
    return result;
}

- (TYLocalPoint *)calculateLocationWithAverage3
{
    TYLocalPoint *result = nil;
    
    if (self.nearestBeacons.count < 3) {
        result = [self calculateBeaconLessThanThree];
    }
    
    if (self.nearestBeacons.count >= 3) {
        int count = (int)MIN(DEFAULT_NUM_FOR_TRIANGULATION, self.nearestBeacons.count);
        NSMutableArray *pointList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 1; ++i) {
            for (int j = i + 1; j < count; ++j) {
                for (int k = j + 1; k < count; ++k) {
                    TYLocalPoint *lp = [self singleTriangulationForB1:[self.nearestBeacons objectAtIndex:i] B2:[self.nearestBeacons objectAtIndex:j] B3:[self.nearestBeacons objectAtIndex:k]];
                    [pointList addObject:lp];
                }
            }
        }
        
        double xSum = 0.0;
        double ySum = 0.0;
        int pointCount = (int)pointList.count;
        
        for (TYLocalPoint *lp in pointList) {
            xSum += lp.x;
            ySum += lp.y;
        }
        
        CLBeacon *nb = [self.nearestBeacons objectAtIndex:0];
        NSNumber *bkey = [TYBeaconKey beaconKeyForCLBeacon:nb];;
        TYPublicBeacon *npb = [self.beaconDictionary objectForKey:bkey];
        
        result = [TYLocalPoint pointWithX:xSum/pointCount Y:ySum/pointCount Floor:npb.location.floor];
    }
    
    return result;
}


@end



@implementation TYHybridTrippleTriangulationAlgorithm

- (TYLocalPoint *)calculationLocation
{
    if (self.nearestBeacons.count < 3) {
        return [self calculateBeaconLessThanThree];
    }
    
    CLBeacon *b1 = [self.nearestBeacons objectAtIndex:0];
    CLBeacon *b2 = [self.nearestBeacons objectAtIndex:1];
        
    if (b1.accuracy/b2.accuracy < 0.33) {
        return [self calculateLocationUsingTripleWithAverage3];
    } else {
        return [self calculateLocationUsingTripleWithAverage4];
    }
}

- (TYLocalPoint *)calculateLocationUsingTripleWithAverage3
{
    TYLocalPoint *result = nil;
    
    if (self.nearestBeacons.count < 3) {
        result = [self calculateBeaconLessThanThree];
    }
    
    if (self.nearestBeacons.count >= 3) {
        int count = (int)MIN(DEFAULT_NUM_FOR_TRIANGULATION, self.nearestBeacons.count);
        NSMutableArray *pointList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 1; ++i) {
            for (int j = i + 1; j < count; ++j) {
                for (int k = j + 1; k < count; ++k) {
                    TYLocalPoint *lp = [self trippleTriangulationForB1:[self.nearestBeacons objectAtIndex:i] B2:[self.nearestBeacons objectAtIndex:j] B3:[self.nearestBeacons objectAtIndex:k]];
                    [pointList addObject:lp];
                }
            }
        }
        
        double xSum = 0.0;
        double ySum = 0.0;
        int pointCount = (int)pointList.count;
        
        for (TYLocalPoint *lp in pointList) {
            xSum += lp.x;
            ySum += lp.y;
        }
        
        CLBeacon *nb = [self.nearestBeacons objectAtIndex:0];
        NSNumber *bkey = [TYBeaconKey beaconKeyForCLBeacon:nb];;
        TYPublicBeacon *npb = [self.beaconDictionary objectForKey:bkey];
        
        result = [TYLocalPoint pointWithX:xSum/pointCount Y:ySum/pointCount Floor:npb.location.floor];
    }
    
    return result;
}

- (TYLocalPoint *)calculateLocationUsingTripleWithAverage4
{
    TYLocalPoint *result = nil;
    
    if (self.nearestBeacons.count < 3) {
        result = [self calculateBeaconLessThanThree];
    }
    
    if (self.nearestBeacons.count >= 3) {
        int count = (int)MIN(DEFAULT_NUM_FOR_TRIANGULATION, self.nearestBeacons.count);
        NSMutableArray *pointList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < count; ++i) {
            for (int j = i + 1; j < count; ++j) {
                for (int k = j + 1; k < count; ++k) {
                    TYLocalPoint *lp = [self trippleTriangulationForB1:[self.nearestBeacons objectAtIndex:i] B2:[self.nearestBeacons objectAtIndex:j] B3:[self.nearestBeacons objectAtIndex:k]];
                    [pointList addObject:lp];
                }
            }
        }
        
        double xSum = 0.0;
        double ySum = 0.0;
        int pointCount = (int)pointList.count;
        
        for (TYLocalPoint *lp in pointList) {
            xSum += lp.x;
            ySum += lp.y;
        }
        
        CLBeacon *nb = [self.nearestBeacons objectAtIndex:0];
        TYPublicBeacon *npb = [self.beaconDictionary objectForKey:nb.minor];
        
        result = [TYLocalPoint pointWithX:xSum/pointCount Y:ySum/pointCount Floor:npb.location.floor];
    }
    
    return result;
}

@end

