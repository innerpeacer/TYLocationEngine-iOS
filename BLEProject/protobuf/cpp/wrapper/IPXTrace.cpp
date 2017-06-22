//
//  IPXTrace.cpp
//  BLEProject
//
//  Created by innerpeacer on 2017/5/30.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#include "IPXTrace.hpp"

using namespace innerpeacer::trace;
using namespace std;

IPXTrace::IPXTrace(innerpeacer::rawdata::IPXPbfDBRecord record)
{
    TYTracePbf pbf;
    pbf.ParseFromArray(record.data, record.dataLength);
    traceID = pbf.traceid();
    timestamp = pbf.timestamp();
    for (int i = 0; i < pbf.points_size(); ++i) {
        TYTracePointPbf p = pbf.points(i);
        points.push_back(IPXTracePoint(p.x(), p.y(), p.floor(), p.timestamp(), p.index()));
    }
}

void IPXTrace::addTracePoint(innerpeacer::trace::IPXTracePoint p)
{
    points.push_back(p);
}

void IPXTrace::addTracePoint(double x, double y, int floor, double timestamp)
{
    int currentIndex = 0;
    if (points.size() > 0) {
        IPXTracePoint tp = points.at(points.size() - 1);
        currentIndex = tp.index + 1;
    }
    IPXTracePoint point(x, y , floor, timestamp, currentIndex);
    points.push_back(point);
}
