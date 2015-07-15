//
//  IPXWeightingAlgorithm.cpp
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#include "IPXWeightingAlgorithm.h"

namespace Innerpeacer {
    namespace BLELocationEngine {
        
        class NPXLinearWeightingAlgorithm : public IPXWeightingAlgorithm {
        public:
            NPXLinearWeightingAlgorithm(const vector<IPXPublicBeacon> &beacons) : IPXWeightingAlgorithm(beacons, NPXLinearWeighting) {}
            const IPXPoint calculationLocation();

        };
        
        const IPXPoint NPXLinearWeightingAlgorithm::calculationLocation()
        {
            vector<double> weightingArray;
            vector<IPXPoint> pointArray;
            double totalWeighting = 0.0;
            double totalWeightingX = 0.0;
            double totalWeightingY = 0.0;
            
            for (int i = 0; i < nearestBeacons.size(); ++i) {
                const IPXScannedBeacon *sb = nearestBeacons.at(i);
                const IPXPublicBeacon pb = GetPublicBeacon(*sb);
                
                double weighting = 1.0/sb->getAccuracy();
                weightingArray.insert(weightingArray.end(), weighting);
                totalWeighting += weighting;
                
                pointArray.insert(pointArray.end(), pb.getLocation());
            }
            
            for (int i = 0; i < weightingArray.size(); ++i) {
                IPXPoint point = pointArray.at(i);
                
                totalWeightingX += point.getX() * weightingArray.at(i);
                totalWeightingY += point.getY() * weightingArray.at(i);
            }
            
            return IPXPoint(totalWeightingX/totalWeighting, totalWeightingY/totalWeighting);
        }

    }
}


namespace Innerpeacer {
    namespace BLELocationEngine {
        
        class NPXQuadraticWeightingAlgorithm : public IPXWeightingAlgorithm {
        public:
            NPXQuadraticWeightingAlgorithm(const vector<IPXPublicBeacon> &beacons) : IPXWeightingAlgorithm(beacons, NPXQuadraticWeighting) {}
            const IPXPoint calculationLocation();
        };
        
        const IPXPoint NPXQuadraticWeightingAlgorithm::calculationLocation()
        {
            vector<double> weightingArray;
            vector<IPXPoint> pointArray;
            double totalWeighting = 0.0;
            double totalWeightingX = 0.0;
            double totalWeightingY = 0.0;
            
            for (int i = 0; i < nearestBeacons.size(); ++i) {
                const IPXScannedBeacon *sb = nearestBeacons.at(i);
                const IPXPublicBeacon pb = GetPublicBeacon(*sb);
                
                double weighting = 1.0/pow(sb->getAccuracy(), 2);
                weightingArray.insert(weightingArray.end(), weighting);
                totalWeighting += weighting;
                
                pointArray.insert(pointArray.end(), pb.getLocation());
            }
            
            for (int i = 0; i < weightingArray.size(); ++i) {
                IPXPoint point = pointArray.at(i);
                
                totalWeightingX += point.getX() * weightingArray.at(i);
                totalWeightingY += point.getY() * weightingArray.at(i);
            }
            
            return IPXPoint(totalWeightingX/totalWeighting, totalWeightingY/totalWeighting);

        }
        
    }
}


IPXWeightingAlgorithm *CreateWeighintAlgorithm(const vector<IPXPublicBeacon> &beacons, IPXAlgorithmType type)
{
    switch (type) {
        case NPXLinearWeighting:
            return new NPXLinearWeightingAlgorithm(beacons);
            break;
            
        case NPXQuadraticWeighting:
            return new NPXQuadraticWeightingAlgorithm(beacons);
            break;
            
        default:
            return nullptr;
            break;
    }
}
