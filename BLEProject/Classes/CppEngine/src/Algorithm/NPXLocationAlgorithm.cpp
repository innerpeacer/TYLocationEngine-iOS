//
//  NPXLocationAlgorithm.cpp
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#include "NPXLocationAlgorithm.h"

#include "NPXTriangulationAlgorithm.h"
#include "NPXWeightingAlgorithm.h"

using namespace Innerpeacer::BLELocationEngine;

NPXLocationAlgorithm::NPXLocationAlgorithm(const vector<IPXPublicBeacon> &beacons, NPXAlgorithmType type) {
    vector<IPXPublicBeacon>::const_iterator iter;
    for (iter = beacons.begin(); iter != beacons.end(); ++iter) {
        publicBeaconMap.insert(BeaconHashMap::value_type((*iter), (*iter)));
    }
    algorithmType = type;
}

void NPXLocationAlgorithm::setNearestBeacons(const vector<const Innerpeacer::BLELocationEngine::IPXScannedBeacon *> &beacons)
{
    nearestBeacons.clear();
    vector<const IPXScannedBeacon *>::const_iterator iter;
    for (iter = beacons.begin(); iter != beacons.end(); ++iter) {
        nearestBeacons.insert(nearestBeacons.end(), *iter);
    }
}

Innerpeacer::BLELocationEngine::NPXLocationAlgorithm *CreateLocationAlgorithm(const vector<IPXPublicBeacon> &beacons, NPXAlgorithmType type)
{
    switch (type) {
        case NPXSingle:
        case NPXTripple:
        case NPXHybridSingle:
        case NPXHybridTripple:
            return CreateTriangulationAlgorithm(beacons, type);
            break;
            
        case NPXLinearWeighting:
        case NPXQuadraticWeighting:
            return CreateWeighintAlgorithm(beacons, type);
            break;
            
        default:
            return nullptr;
            break;
    }
}
