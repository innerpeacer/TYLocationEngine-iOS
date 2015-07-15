//
//  NPXLocationAlgorithm.h
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#ifndef __BLEProject__NPXLocationAlgorithm__
#define __BLEProject__NPXLocationAlgorithm__

#include <stdio.h>

#include <unordered_map>
#include <map>
#include <vector>
#include "IPXPoint.h"
#include "IPXScannedBeacon.h"
#include "IPXPublicBeacon.h"
#include "NPXAlgorithmType.h"

using namespace std;
using namespace Innerpeacer::BLELocationEngine;

typedef unordered_map<IPXBeacon, IPXPublicBeacon, hash_beacon_key, equal_beacon_key> BeaconHashMap;

namespace Innerpeacer {
    namespace BLELocationEngine {
        
        
        class NPXLocationAlgorithm {
            
        public:
            NPXLocationAlgorithm(const vector<IPXPublicBeacon> &beacons, NPXAlgorithmType type);
            void setNearestBeacons(const vector<const IPXScannedBeacon *> &beacons);
            virtual const IPXPoint calculationLocation() = 0;
            virtual ~NPXLocationAlgorithm() {};
            
        protected:
            NPXAlgorithmType algorithmType;
            vector<const IPXScannedBeacon *> nearestBeacons;
            BeaconHashMap publicBeaconMap;

            const bool HasPublicBeacon(const IPXBeacon &key) const {
                return publicBeaconMap.find(key) != publicBeaconMap.end();
            }
            
            const IPXPublicBeacon & GetPublicBeacon(const IPXBeacon &key) const {
                return publicBeaconMap.at(key);
            }
            
            IPXPublicBeacon & GetPublicBeacon(const IPXBeacon &key) {
                return publicBeaconMap.at(key);
            }
            
        };
    }
}

Innerpeacer::BLELocationEngine::NPXLocationAlgorithm *CreateLocationAlgorithm(const vector<IPXPublicBeacon> &beacons, NPXAlgorithmType type);



#endif /* defined(__BLEProject__NPXLocationAlgorithm__) */
