

#include <sqlite3.h>

#include "CppUnionLane.h"
#include <geos/operation/union/CascadedUnion.h>
#include <geos/opBuffer.h>
#include <geos/geom/prep/PreparedPolygon.h>
#include <geos/operation/distance/DistanceOp.h>

using namespace geos::operation::geounion;
using namespace geos::operation::buffer;
using namespace geos::geom::prep;
using namespace geos::operation::distance;

using namespace Innerpeacer::BLELocationEngine;

bool geometryContains(geos::geom::Geometry *geometry1, geos::geom::Geometry *geometry2)
{
    PreparedPolygon polygon1(geometry1);
    return polygon1.contains(geometry2);
}

Point *CppUnionLane::snapToLane(Geometry *line, Point *point)
{
    CoordinateSequence *sequences = DistanceOp::nearestPoints(line, point);

    Point *resultPoint = NULL;

    if (sequences->size() > 0) {
        resultPoint = this->createPoint(sequences->front().x, sequences->front().y);
    }
    delete sequences;
    return resultPoint;
}

CppUnionLane::CppUnionLane(const char *path, double bufferDistance)
{
    WKBReader reader;
    
    vector<Geometry *> lineStringVector;
    sqlite3 *db = NULL;
    int ret = sqlite3_open(path, &db);

    if (ret == SQLITE_OK) {
        stringstream s;
        sqlite3_stmt *stmt = NULL;
        ret = sqlite3_prepare_v2(db, "select GEOMETRY from polyline", 29, &stmt, NULL);
        
        if (ret == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                s.clear();
                s.write((const char *)sqlite3_column_blob(stmt, 0), sqlite3_column_bytes(stmt, 0));
                lineStringVector.insert(lineStringVector.end(), dynamic_cast<LineString *>(reader.read(s)));
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(db);
    }
    
    unionLane =  dynamic_cast<MultiLineString *>(CascadedUnion::Union(&lineStringVector));
    unionLaneBuffer = dynamic_cast<Polygon *>(BufferOp::bufferOp(unionLane, bufferDistance));

    factory = new GeometryFactory();
}

IPXPoint CppUnionLane::snappedToLanes(Innerpeacer::BLELocationEngine::IPXPoint point)
{
    IPXPoint resultPoint(point);
    
    geos::geom::Point *originalPoint = this->createPoint(point.getX(), point.getY());
    if (geometryContains(unionLaneBuffer, originalPoint)) {
        geos::geom::Point *snappedPoint = this->snapToLane(unionLane,originalPoint);
        resultPoint = IPXPoint(snappedPoint->getX(), snappedPoint->getY(), point.getFloor());
        delete snappedPoint;
    }
    
    delete originalPoint;

    return resultPoint;
}



geos::geom::Point * CppUnionLane::createPoint(double x, double y)
{
    Coordinate c;
    c.x = x;
    c.y = y;
    return factory->createPoint(c);
}
