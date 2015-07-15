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
#include "NPXPoint.h"
#include "NPXScannedBeacon.h"
#include "NPXPublicBeacon.h"
#include "NPXAlgorithmType.h"

using namespace std;
using namespace Innerpeacer::BLELocationEngine;

typedef unordered_map<NPXBeacon, NPXPublicBeacon, hash_beacon_key, equal_beacon_key> BeaconHashMap;

namespace Innerpeacer {
    namespace BLELocationEngine {
        
        
        class NPXLocationAlgorithm {
            
        public:
            NPXLocationAlgorithm(const vector<NPXPublicBeacon> &beacons, NPXAlgorithmType type);
            void setNearestBeacons(const vector<const NPXScannedBeacon *> &beacons);
            virtual const NPXPoint calculationLocation() = 0;
            virtual ~NPXLocationAlgorithm() {};
            
        protected:
            NPXAlgorithmType algorithmType;
            vector<const NPXScannedBeacon *> nearestBeacons;
            BeaconHashMap publicBeaconMap;

            const bool HasPublicBeacon(const NPXBeacon &key) const {
                return publicBeaconMap.find(key) != publicBeaconMap.end();
            }
            
            const NPXPublicBeacon & GetPublicBeacon(const NPXBeacon &key) const {
                return publicBeaconMap.at(key);
            }
            
            NPXPublicBeacon & GetPublicBeacon(const NPXBeacon &key) {
                return publicBeaconMap.at(key);
            }
            
        };
    }
}

Innerpeacer::BLELocationEngine::NPXLocationAlgorithm *CreateLocationAlgorithm(const vector<NPXPublicBeacon> &beacons, NPXAlgorithmType type);



#endif /* defined(__BLEProject__NPXLocationAlgorithm__) */
