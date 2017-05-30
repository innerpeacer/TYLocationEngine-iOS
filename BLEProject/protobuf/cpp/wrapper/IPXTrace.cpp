//
//  IPXTrace.cpp
//  BLEProject
//
//  Created by innerpeacer on 2017/5/30.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#include "IPXTrace.hpp"

using namespace innerpeacer::rawdata;
using namespace std;

void IPXTrace::addTracePoint(innerpeacer::rawdata::IPXTracePoint p)
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
