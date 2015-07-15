//
//
//#ifndef __NPTestProject__NPXGeometryEngine__
//#define __NPTestProject__NPXGeometryEngine__
//
//#include <geos.h>
//
//
//using namespace std;
//using namespace geos;
//using namespace geos::geom;
//
//namespace Innerpeacer {
//    namespace BLELocationEngine {
//        
//        class NPXGeometryEngine
//        {
//        private:
//            GeometryFactory *factory;
//            
//            
//        public:
//            NPXGeometryEngine()
//            {
//                factory = new GeometryFactory();
//            }
//            
//            virtual ~NPXGeometryEngine()
//            {
//                delete factory;
//            }
//            
//            geos::geom::Point *createPoint(double x, double y);
//            
//            Polygon *bufferGeometry(geos::geom::Geometry *geometry, double distance);
//            MultiPolygon *unionPolygons(vector<Polygon *> polygonArray);
//            MultiLineString *unionPolylines(vector<LineString *> polylineArray);
//            MultiPoint *unionPoints(vector<geos::geom::Point *> pointArray);
//            
//            bool geometryContains(geos::geom::Geometry *geometry1, geos::geom::Geometry *geometry2);
//            geos::geom::Point *snapToLane(Geometry *line, geos::geom::Point *point);
//        };
//        
//        
//    }
//}
//
//#endif /* defined(__NPTestProject__NPXGeometryEngine__) */
