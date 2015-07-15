/*
 * ILocationEngine.h
 *
 *  Created on: 2014-9-3
 *      Author: innerpeacer
 */

#ifndef ILOCATIONENGINE_H_
#define ILOCATIONENGINE_H_

#include <vector>
#include "NPXScannedBeacon.h"
#include "NPXPoint.h"
#include "NPXPublicBeacon.h"
#include "NPXAlgorithmType.h"

using namespace Innerpeacer::BLELocationEngine;

namespace Innerpeacer {
    namespace BLELocationEngine {
        struct ILocationEngine {
        public:
            ILocationEngine() {};
            virtual void Initilize(const vector<NPXPublicBeacon> &beacons) = 0;
            virtual void processBeacons(vector<const NPXScannedBeacon *> &beacons) = 0;
            virtual void addStepEvent() = 0;
            virtual void reset() = 0;
            virtual NPXPoint getLocation() const = 0;
            virtual ~ILocationEngine() {};
        };
    }
}

ILocationEngine *CreateNPXStepBaseTriangulationEngine(NPXAlgorithmType type);

#endif /* ILOCATIONENGINE_H_ */
