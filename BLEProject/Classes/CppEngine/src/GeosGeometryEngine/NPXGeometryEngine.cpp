#include "NPXGeometryEngine.h"

#include <geos/opBuffer.h>

#include <geos/operation/union/UnaryUnionOp.h>
#include <geos/operation/union/CascadedPolygonUnion.h>
#include <geos/operation/union/CascadedUnion.h>
#include <geos/geom/prep/PreparedPolygon.h>
#include <geos/operation/distance/DistanceOp.h>

using namespace geos::operation::buffer;
using namespace geos::operation::geounion;
using namespace geos::geom::prep;
using namespace geos::operation::distance;


using namespace Innerpeacer::BLELocationEngine;

Polygon * NPXGeometryEngine::bufferGeometry(geos::geom::Geometry *geometry, double distance)
{
    return dynamic_cast<Polygon *>(BufferOp::bufferOp(geometry, distance));
}

MultiPolygon * NPXGeometryEngine::unionPolygons(vector<geos::geom::Polygon *> polygonArray)
{
    MultiPolygon *resultPolygon = dynamic_cast<MultiPolygon *>(CascadedPolygonUnion::Union(&polygonArray));
    return resultPolygon;
}

MultiLineString *NPXGeometryEngine::unionPolylines(vector<LineString *> polylineArray)
{
    vector<Geometry *> geomArray;
    
    vector<LineString *>::iterator iter;
    for (iter = polylineArray.begin(); iter != polylineArray.end(); ++iter) {
        geomArray.insert(geomArray.end(), *iter);
    }
    
    MultiLineString *resultLineString = dynamic_cast<MultiLineString *>(CascadedUnion::Union(&geomArray));
    return resultLineString;
}

MultiPoint *NPXGeometryEngine::unionPoints(vector<geos::geom::Point *> pointArray)
{
    vector<Geometry *> geomArray;
    vector<geos::geom::Point *>::iterator iter;
    for (iter = pointArray.begin(); iter != pointArray.end(); ++iter) {
        geomArray.insert(geomArray.end(), *iter);
    }
    
    MultiPoint *resultMultiPoint = dynamic_cast<MultiPoint *>(CascadedUnion::Union(&geomArray));
    return resultMultiPoint;
}

bool NPXGeometryEngine::geometryContains(geos::geom::Geometry *geometry1, geos::geom::Geometry *geometry2)
{
    PreparedPolygon polygon1(geometry1);
    return polygon1.contains(geometry2);
}

Point *NPXGeometryEngine::snapToLane(Geometry *line, geos::geom::Point *point)
{
    CoordinateSequence *sequences = DistanceOp::nearestPoints(line, point);
    
    geos::geom::Point *resultPoint = NULL;
    
    if (sequences->size() > 0) {
        Coordinate coord;
        coord.x = sequences->front().x;
        coord.y = sequences->front().y;
        
        resultPoint = factory->createPoint(coord);
    }
    delete sequences;
    
    return resultPoint;
    
}

Point *NPXGeometryEngine::createPoint(double x, double y)
{
    Coordinate c;
    c.x = x;
    c.y = y;
    return factory->createPoint(c);
}
