//
//  NPXTriangulationAlgorithm.h
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#ifndef __BLEProject__NPXTriangulationAlgorithm__
#define __BLEProject__NPXTriangulationAlgorithm__

#include <stdio.h>
#include "NPXLocationAlgorithm.h"

using namespace Innerpeacer::BLELocationEngine;

namespace Innerpeacer {
    namespace BLELocationEngine {
        
        class NPXTriangulationAlgorithm: public NPXLocationAlgorithm {
            
        public:
            NPXTriangulationAlgorithm(const vector<IPXPublicBeacon> &beacons, NPXAlgorithmType type) : NPXLocationAlgorithm(beacons, type) {}
            virtual const IPXPoint calculationLocation() = 0;
            
        protected:
            IPXPoint pointFor(const IPXPoint &p1, double a1,const IPXPoint &p2, double a2);

            IPXPoint calculateBeaconLessThanThree();
            IPXPoint calculateOneBeacon(const IPXScannedBeacon *beacon);
            IPXPoint calculateTwoBeacons(const IPXScannedBeacon *b1, const IPXScannedBeacon *b2);
            IPXPoint singleTriangulation(const IPXScannedBeacon *b1, const IPXScannedBeacon *b2,const IPXScannedBeacon *b3);
            IPXPoint tripleTriangulation(const IPXScannedBeacon *b1, const IPXScannedBeacon *b2, const IPXScannedBeacon *b3);
        };
    }
}

NPXTriangulationAlgorithm *CreateTriangulationAlgorithm(const vector<IPXPublicBeacon> &beacons, NPXAlgorithmType type);


#endif /* defined(__BLEProject__NPXTriangulationAlgorithm__) */
