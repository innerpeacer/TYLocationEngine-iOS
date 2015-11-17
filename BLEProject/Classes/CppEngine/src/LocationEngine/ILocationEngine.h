/*
 * ILocationEngine.h
 *
 *  Created on: 2014-9-3
 *      Author: innerpeacer
 */

#ifndef ILOCATIONENGINE_H_
#define ILOCATIONENGINE_H_

#include <vector>
#include "IPXScannedBeacon.h"
#include "IPXPoint.h"
#include "IPXPublicBeacon.h"
#include "IPXAlgorithmType.h"

using namespace Innerpeacer::BLELocationEngine;

namespace Innerpeacer {
    namespace BLELocationEngine {
        struct ILocationEngine {
        public:
            ILocationEngine() {};
            virtual void Initilize(const vector<IPXPublicBeacon> &beacons, std::string checkCode) = 0;
            virtual void processBeacons(vector<const IPXScannedBeacon *> &beacons) = 0;
            virtual void addStepEvent() = 0;
            virtual void reset() = 0;
            virtual IPXPoint getLocation() const = 0;
            virtual IPXPoint getImmediateLocation() const = 0;
            virtual ~ILocationEngine() {};
        };
    }
}

ILocationEngine *CreateIPXStepBaseTriangulationEngine(IPXAlgorithmType type);

#endif /* ILOCATIONENGINE_H_ */
