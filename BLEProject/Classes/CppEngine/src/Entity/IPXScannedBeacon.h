/*
 * IPXScannedBeacon.h
 *
 *  Created on: 2014-9-2
 *      Author: innerpeacer
 */

#ifndef NPXSCANNEDBEACON_H_
#define NPXSCANNEDBEACON_H_

#include "IPXBeacon.h"

using namespace std;

namespace Innerpeacer {
namespace BLELocationEngine {

typedef enum {
	NPXProximityUnknwon = 0, NPXProximityImmediate, NPXProximityNear, NPXProximityFar
} NPXProximity;

class IPXScannedBeacon: public IPXBeacon {
public:
	IPXScannedBeacon(const char *uuid, uint16_t major, uint16_t minor, int rssi,
			double accuracy, NPXProximity proximity) :
			IPXBeacon(uuid, major, minor), rssi(rssi), accuracy(accuracy), proximity(
					proximity) {

	}
	virtual ~IPXScannedBeacon() {
        
    }

	int getRssi() const {
		return rssi;
	}

	double getAccuracy() const {
		return accuracy;
	}

	NPXProximity getProximity() const {
		return proximity;
	}

private:
	int rssi;
	double accuracy;
	NPXProximity proximity;
};
}
}

#endif /* NPXSCANNEDBEACON_H_ */
