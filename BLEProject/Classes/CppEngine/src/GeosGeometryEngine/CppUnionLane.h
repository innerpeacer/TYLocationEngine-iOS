

#ifndef __TYTestProject__CppLaneManager__
#define __TYTestProject__CppLaneManager__

#include <string>

#include <geos.h>
#include <sstream>

#include "IPXPoint.h"

using namespace std;
using namespace geos;
using namespace geos::geom;
using namespace Innerpeacer::BLELocationEngine;

namespace Innerpeacer {
namespace BLELocationEngine {
 
    class CppUnionLane
    {
    private:
        GeometryFactory *factory;
        MultiLineString *unionLane;
        Polygon *unionLaneBuffer;
        
        geos::geom::Point *createPoint(double x, double y);
        geos::geom::Point *snapToLane(Geometry *line, geos::geom::Point *point);

    public:
        
        CppUnionLane(const char *path, double bufferDistance);
        
        ~CppUnionLane()
        {
            delete factory;
            if (unionLane) {
                delete unionLane;
            }
            
            if (unionLaneBuffer) {
                delete unionLaneBuffer;
            }
        }
        
        IPXPoint snappedToLanes(IPXPoint point);
        
    };
    
}
}

#endif /* defined(__TYTestProject__CppLaneManager__) */
