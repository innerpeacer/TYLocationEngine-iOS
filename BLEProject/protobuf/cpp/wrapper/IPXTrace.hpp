//
//  IPXTrace.hpp
//  BLEProject
//
//  Created by innerpeacer on 2017/5/30.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#ifndef IPXTrace_hpp
#define IPXTrace_hpp

#include <stdio.h>
#include <string>
#include <vector>
#include "t_y_trace_pbf.pb.h"
#include "IPXPbfDBRecord.hpp"

namespace innerpeacer {
    namespace trace {
        
        class IPXTracePoint {
        public:
            double x;
            double y;
            int floor;
            double timestamp;
            int index;
            
            IPXTracePoint(double x, double y, int f, double time, int index) : x(x), y(y), floor(f), timestamp(time), index(index) {}
        };
        
        class IPXTrace {
        public:
            std::string traceID;
            double timestamp;
            std::vector<IPXTracePoint> points;
            
            IPXTrace(std::string tID, double time) : traceID(tID), timestamp(time) {}
            IPXTrace(std::string tID, double time, std::vector<IPXTracePoint> points) : traceID(tID), timestamp(time), points(points) {}
            IPXTrace(innerpeacer::rawdata::IPXPbfDBRecord record);
            
            void addTracePoint(IPXTracePoint p);
            void addTracePoint(double x, double y, int floor, double timestamp);
            
            
        };
    }
}

#endif /* IPXTrace_hpp */
