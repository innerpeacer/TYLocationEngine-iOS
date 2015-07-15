#import "TYGeometryCalculator.h"

@implementation TYGeometryCalculator

+ (TYLocalPoint *)scalePointWithCenter:(TYLocalPoint *)center scaled:(TYLocalPoint *)scaledPoint ForLength:(double)length
{
    double distance = [TYLocalPoint distanceBetween:center and:scaledPoint];
    
    if (distance <= length) {
        return scaledPoint;
    }
    
    double scale = length / distance;
    
    double x = scale * scaledPoint.x + (1 - scale) * center.x;
    double y = scale * scaledPoint.y + (1 - scale) * center.y;
    
    return [TYLocalPoint pointWithX:x Y:y Floor:scaledPoint.floor];
}

@end
