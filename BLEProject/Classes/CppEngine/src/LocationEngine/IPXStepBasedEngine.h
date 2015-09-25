//
//  IPXStepBasedEngine.h
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#ifndef __BLEProject__IPXStepBasedEngine__
#define __BLEProject__IPXStepBasedEngine__

#include <stdio.h>

#include "ILocationEngine.h"
#include "IPXMovingAverage.h"
#include "IPXLocationAlgorithm.h"

const int DefaultMovingAverageWindow = 10;
const int DefaultStep = 1;
const double DefaultStepLength = 0.6;

using namespace Innerpeacer::BLELocationEngine;

namespace Innerpeacer {
    namespace BLELocationEngine {
        
        class IPXStepBasedEngine : public ILocationEngine {
        public:
            IPXStepBasedEngine(IPXAlgorithmType type):algorithmType(type) {
                algorithm = NULL;
            }
            
            void Initilize(const vector<IPXPublicBeacon> &beacons, std::string checkCode);
            void processBeacons(vector<const IPXScannedBeacon *> &beacons);
            void addStepEvent();
            void reset();
            IPXPoint getLocation() const;
            
            ~IPXStepBasedEngine() {
                if (algorithm)
                    delete algorithm;
            }
            
        private:
            IPXLocationAlgorithm *algorithm;
            IPXAlgorithmType algorithmType;
            
            IPXPoint currentDisplayLocation;
            IPXPoint currentAnchorLocation;
            
            IPXMovingAverage xMovingAverage;
            IPXMovingAverage yMovingAverage;
            
            int stepCount;
            
            IPXPoint getIndependentLocation();

            bool isBeaconDataComplete;
        };
        
    }
}


#endif /* defined(__BLEProject__IPXStepBasedEngine__) */
