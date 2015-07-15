//
//  NPXTriangulationAlgorithm.cpp
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#include "NPXTriangulationAlgorithm.h"

#define DEFAULT_NUM_FOR_TRIANGULATION 4


IPXPoint NPXTriangulationAlgorithm::pointFor(const IPXPoint &p1, double a1,const IPXPoint &p2, double a2)
{
    double sum = a1 + a2;
    double x = (a1 * p2.getX() + a2 * p1.getX()) / sum;
    double y = (a1 * p2.getY() + a2 * p1.getY()) / sum;
    
    return IPXPoint(x, y, p1.getFloor());
}

IPXPoint NPXTriangulationAlgorithm::calculateBeaconLessThanThree()
{
    if (nearestBeacons.size() == 1) {
        return calculateOneBeacon(nearestBeacons.at(0));
    }
    
    if (nearestBeacons.size() == 2) {
        return calculateTwoBeacons(nearestBeacons.at(0), nearestBeacons.at(1));
    }
    return INVALID_POINT;
}

IPXPoint NPXTriangulationAlgorithm::calculateOneBeacon(const IPXScannedBeacon *beacon)
{
    if (beacon->getProximity() == NPXProximityImmediate
        || beacon->getProximity() == NPXProximityNear) {
        IPXPublicBeacon pb = GetPublicBeacon(*beacon);
        IPXPoint location = pb.getLocation();
        return IPXPoint(location);
    }
    return INVALID_POINT;
}

IPXPoint NPXTriangulationAlgorithm::calculateTwoBeacons(const IPXScannedBeacon *b1, const IPXScannedBeacon *b2)
{
    const IPXPublicBeacon pb1 = GetPublicBeacon(*b1);
    const IPXPublicBeacon pb2 = GetPublicBeacon(*b2);
    
    IPXPoint p1 = pb1.getLocation();
    IPXPoint p2 = pb2.getLocation();
    
    return pointFor(p1, b1->getAccuracy(), p2, b2->getAccuracy());
}

IPXPoint NPXTriangulationAlgorithm::singleTriangulation(const IPXScannedBeacon *b1, const IPXScannedBeacon *b2,const IPXScannedBeacon *b3)
{
    const IPXPublicBeacon pb1 = GetPublicBeacon(*b1);
    const IPXPublicBeacon pb2 = GetPublicBeacon(*b2);
    const IPXPublicBeacon pb3 = GetPublicBeacon(*b3);
    
    IPXPoint p1 = pb1.getLocation();
    IPXPoint p2 = pb2.getLocation();
    IPXPoint p3 = pb3.getLocation();
    
    IPXPoint p12 = pointFor(p1, b1->getAccuracy(), p2, b2->getAccuracy());
    IPXPoint p13 = pointFor(p1, b1->getAccuracy(), p3, b3->getAccuracy());
    
    IPXPoint result = pointFor(p12, b2->getAccuracy(), p13, b3->getAccuracy());
    result.setFloor(pb1.getLocation().getFloor());
    
    return result;
}

IPXPoint NPXTriangulationAlgorithm::tripleTriangulation(const IPXScannedBeacon *b1, const IPXScannedBeacon *b2, const IPXScannedBeacon *b3)
{
    IPXPoint t123 = singleTriangulation(b1, b2, b3);
    IPXPoint t231 = singleTriangulation(b2, b3, b1);
    IPXPoint t312 = singleTriangulation(b3, b1, b2);
    
    double x = (t123.getX() + t231.getX() + t312.getX()) / 3.0;
    double y = (t123.getY() + t231.getY() + t312.getY()) / 3.0;
    
    return IPXPoint(x, y, t123.getFloor());
}


namespace Innerpeacer {
    namespace BLELocationEngine {

        class NPXSingleTriangulationAlgorithm : public NPXTriangulationAlgorithm {
        public:
            NPXSingleTriangulationAlgorithm(const vector<IPXPublicBeacon> &beacons) : NPXTriangulationAlgorithm(beacons, NPXSingle) {}
            const IPXPoint calculationLocation();
            
        protected:
            
        };
        
        const IPXPoint NPXSingleTriangulationAlgorithm::calculationLocation()
        {
            if (nearestBeacons.size() < 3) {
                return calculateBeaconLessThanThree();
            } else {
                return singleTriangulation(nearestBeacons.at(0), nearestBeacons.at(1), nearestBeacons.at(2));
            }
            return INVALID_POINT;
        }
        
    }
}


namespace Innerpeacer {
    namespace BLELocationEngine {
        
        class NPXTrippleTriangulationAlgorithm : public NPXTriangulationAlgorithm {
        public:
            NPXTrippleTriangulationAlgorithm(const vector<IPXPublicBeacon> &beacons) : NPXTriangulationAlgorithm(beacons, NPXTripple) {}
            const IPXPoint calculationLocation();
        };
        
        const IPXPoint NPXTrippleTriangulationAlgorithm::calculationLocation()
        {
            if (nearestBeacons.size() < 3) {
                return calculateBeaconLessThanThree();
            } else {
                return tripleTriangulation((IPXScannedBeacon *)nearestBeacons.at(0), (IPXScannedBeacon *)nearestBeacons.at(1), (IPXScannedBeacon *)nearestBeacons.at(2));
            }
            return INVALID_POINT;
        }
    }
}

namespace Innerpeacer {
    namespace BLELocationEngine {
        
        class NPXHybridSingleTriangulationAlgorithm : public NPXTriangulationAlgorithm {
        public:
            NPXHybridSingleTriangulationAlgorithm(const vector<IPXPublicBeacon> &beacons) : NPXTriangulationAlgorithm(beacons, NPXHybridSingle) {}
            const IPXPoint calculationLocation();
            
        private:
            IPXPoint calculateLocationWithAverage3();
            IPXPoint calculateLocationWithAverage4();
        };
        
        const IPXPoint NPXHybridSingleTriangulationAlgorithm::calculationLocation()
        {
            if (nearestBeacons.size() < 3) {
                return calculateBeaconLessThanThree();
            } else {
                const IPXScannedBeacon *b1 = nearestBeacons.at(0);
                const IPXScannedBeacon *b2 = nearestBeacons.at(1);
                
                if (b1->getAccuracy() / b2->getAccuracy() < 0.33) {
                    return calculateLocationWithAverage3();
                } else {
                    return calculateLocationWithAverage4();
                }
            }
            return INVALID_POINT;
        }
        
        IPXPoint NPXHybridSingleTriangulationAlgorithm::calculateLocationWithAverage3()
        {
            if (nearestBeacons.size() < 3) {
                return calculateBeaconLessThanThree();
            }
            
            if (nearestBeacons.size() >= 3) {
                int count = (int)std::min((int)DEFAULT_NUM_FOR_TRIANGULATION,(int)nearestBeacons.size());
                
                vector<IPXPoint> pointVector;
                for (int i = 0; i < 1; ++i) {
                    for (int j = i + 1; j < count; ++j) {
                        for (int k = j + 1; k < count; ++k) {
                            IPXPoint p = singleTriangulation(nearestBeacons.at(i), nearestBeacons.at(j), nearestBeacons.at(k));
                            pointVector.insert(pointVector.end(), p);
                        }
                    }
                }
                
                double xSum = 0.0;
                double ySum = 0.0;
                int pointCount = (int) pointVector.size();
                
                vector<IPXPoint>::iterator iter;
                for (iter = pointVector.begin(); iter != pointVector.end(); ++iter) {
                    xSum += iter->getX();
                    ySum += iter->getY();
                }
                
                IPXPublicBeacon npb = GetPublicBeacon(*(nearestBeacons.at(0)));
                
                return IPXPoint(xSum/pointCount, ySum/pointCount, npb.getLocation().getFloor());
            }
            
            return INVALID_POINT;
        }
        
        IPXPoint NPXHybridSingleTriangulationAlgorithm::calculateLocationWithAverage4()
        {
            if (nearestBeacons.size() < 3) {
                return calculateBeaconLessThanThree();
            }
            
            if (nearestBeacons.size() >= 3) {
                int count = (int)std::min((int)DEFAULT_NUM_FOR_TRIANGULATION,(int)nearestBeacons.size());
                
                vector<IPXPoint> pointVector;
                for (int i = 0; i < count; ++i) {
                    for (int j = i + 1; j < count; ++j) {
                        for (int k = j + 1; k < count; ++k) {
                            IPXPoint p = singleTriangulation(nearestBeacons.at(i), nearestBeacons.at(j), nearestBeacons.at(k));
                            pointVector.insert(pointVector.end(), p);
                        }
                    }
                }
                
                double xSum = 0.0;
                double ySum = 0.0;
                int pointCount = (int) pointVector.size();
                
                vector<IPXPoint>::iterator iter;
                for (iter = pointVector.begin(); iter != pointVector.end(); ++iter) {
                    xSum += iter->getX();
                    ySum += iter->getY();
                }
                
                IPXPublicBeacon npb = GetPublicBeacon(*(nearestBeacons.at(0)));
                
                return IPXPoint(xSum/pointCount, ySum/pointCount, npb.getLocation().getFloor());
            }
            
            return INVALID_POINT;
        }
    }
}

namespace Innerpeacer {
    namespace BLELocationEngine {
        
        class NPXHybridTrippleTriangulationAlgorithm : public NPXTriangulationAlgorithm {
        public:
            NPXHybridTrippleTriangulationAlgorithm(const vector<IPXPublicBeacon> &beacons) : NPXTriangulationAlgorithm(beacons, NPXHybridTripple) {}
            const IPXPoint calculationLocation();
            
        private:
            const IPXPoint calculateLocationUsingTripleWithAverage3();
            const IPXPoint calculateLocationUsingTripleWithAverage4();

        };
        
        const IPXPoint NPXHybridTrippleTriangulationAlgorithm::calculationLocation()
        {
            if (nearestBeacons.size() < 3) {
                return calculateBeaconLessThanThree();
            } else {
                const IPXScannedBeacon *b1 = nearestBeacons.at(0);
                const IPXScannedBeacon *b2 = nearestBeacons.at(1);
                
                if (b1->getAccuracy() / b2->getAccuracy() < 0.33) {
                    return calculateLocationUsingTripleWithAverage3();
                } else {
                    return calculateLocationUsingTripleWithAverage4();
                }
            }
            return INVALID_POINT;
        }
        
        const IPXPoint NPXHybridTrippleTriangulationAlgorithm::calculateLocationUsingTripleWithAverage3()
        {
            if (nearestBeacons.size() < 3) {
                return calculateBeaconLessThanThree();
            }
            
            if (nearestBeacons.size() >= 3) {
                int count = (int)std::min((int)DEFAULT_NUM_FOR_TRIANGULATION,(int)nearestBeacons.size());
                
                vector<IPXPoint> pointVector;
                for (int i = 0; i < 1; ++i) {
                    for (int j = i + 1; j < count; ++j) {
                        for (int k = j + 1; k < count; ++k) {
                            IPXPoint p = tripleTriangulation(nearestBeacons.at(i), nearestBeacons.at(j), nearestBeacons.at(k));
                            pointVector.insert(pointVector.end(), p);
                        }
                    }
                }
                
                double xSum = 0.0;
                double ySum = 0.0;
                int pointCount = (int) pointVector.size();
                
                vector<IPXPoint>::iterator iter;
                for (iter = pointVector.begin(); iter != pointVector.end(); ++iter) {
                    xSum += iter->getX();
                    ySum += iter->getY();
                }
                
                IPXPublicBeacon npb = GetPublicBeacon(*(nearestBeacons.at(0)));
                
                return IPXPoint(xSum/pointCount, ySum/pointCount, npb.getLocation().getFloor());
            }
            return INVALID_POINT;
        }
        
        const IPXPoint NPXHybridTrippleTriangulationAlgorithm::calculateLocationUsingTripleWithAverage4()
        {
            if (nearestBeacons.size() < 3) {
                return calculateBeaconLessThanThree();
            }
            
            if (nearestBeacons.size() >= 3) {
                int count = (int)std::min((int)DEFAULT_NUM_FOR_TRIANGULATION,(int)nearestBeacons.size());
                vector<IPXPoint> pointVector;
                for (int i = 0; i < count; ++i) {
                    for (int j = i + 1; j < count; ++j) {
                        for (int k = j + 1; k < count; ++k) {
                            IPXPoint p = tripleTriangulation(nearestBeacons.at(i), nearestBeacons.at(j), nearestBeacons.at(k));
                            pointVector.insert(pointVector.end(), p);
                        }
                    }
                }
                
                double xSum = 0.0;
                double ySum = 0.0;
                int pointCount = (int) pointVector.size();
                
                vector<IPXPoint>::iterator iter;
                for (iter = pointVector.begin(); iter != pointVector.end(); ++iter) {
                    xSum += iter->getX();
                    ySum += iter->getY();
                }
                
                IPXPublicBeacon npb = GetPublicBeacon(*(nearestBeacons.at(0)));
                
                return IPXPoint(xSum/pointCount, ySum/pointCount, npb.getLocation().getFloor());
            }
            return INVALID_POINT;
        }

    }
}

NPXTriangulationAlgorithm *CreateTriangulationAlgorithm(const vector<IPXPublicBeacon> &beacons, NPXAlgorithmType type)
{
    switch (type) {
        case NPXSingle:
            return new NPXSingleTriangulationAlgorithm(beacons);
            break;
            
        case NPXTripple:
            return new NPXTrippleTriangulationAlgorithm(beacons);
            break;
            
        case NPXHybridSingle:
            return new NPXHybridSingleTriangulationAlgorithm(beacons);
            break;
            
        case NPXHybridTripple:
            return new NPXHybridTrippleTriangulationAlgorithm(beacons);
            break;
            
        default:
            return nullptr;
            break;
    }
}