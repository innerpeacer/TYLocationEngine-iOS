

#ifndef __NPTestProject__IPXGeometryEngine__
#define __NPTestProject__IPXGeometryEngine__

#include <geos.h>


using namespace std;
using namespace geos;
using namespace geos::geom;

namespace Innerpeacer {
    namespace BLELocationEngine {
        
        class IPXGeometryEngine
        {
        private:
            GeometryFactory *factory;
            
            
        public:
            IPXGeometryEngine()
            {
                factory = new GeometryFactory();
            }
            
            virtual ~IPXGeometryEngine()
            {
                delete factory;
            }
            
            geos::geom::Point *createPoint(double x, double y);
            
            Polygon *bufferGeometry(geos::geom::Geometry *geometry, double distance);
            MultiPolygon *unionPolygons(vector<Polygon *> polygonArray);
            MultiLineString *unionPolylines(vector<LineString *> polylineArray);
            MultiPoint *unionPoints(vector<geos::geom::Point *> pointArray);
            
            bool geometryContains(geos::geom::Geometry *geometry1, geos::geom::Geometry *geometry2);
            geos::geom::Point *snapToLane(Geometry *line, geos::geom::Point *point);
        };
        
        
    }
}

#endif /* defined(__NPTestProject__IPXGeometryEngine__) */
