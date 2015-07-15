//
//  NPXStepBasedEngine.cpp
//  BLEProject
//
//  Created by innerpeacer on 15/2/11.
//  Copyright (c) 2015年 innerpeacer. All rights reserved.
//

#include "NPXStepBasedEngine.h"
#include "NPXGeometryCalculator.h"

using namespace Innerpeacer::BLELocationEngine;

ILocationEngine *CreateNPXStepBaseTriangulationEngine(IPXAlgorithmType type)
{
    return new NPXStepBasedEngine(type);
}

void NPXStepBasedEngine::Initilize(const vector<Innerpeacer::BLELocationEngine::IPXPublicBeacon> &beacons ) {
    if (algorithm) {
        delete algorithm;
    }
    
    algorithm = CreateLocationAlgorithm(beacons, algorithmType);
    
    xMovingAverage = IPXMovingAverage(DefaultMovingAverageWindow);
    yMovingAverage = IPXMovingAverage(DefaultMovingAverageWindow);
    
    stepCount = DefaultStep;
    
    printf("NPXStepBasedTEngine::Initilize OK!");
}


void NPXStepBasedEngine::processBeacons(vector<const Innerpeacer::BLELocationEngine::IPXScannedBeacon *> &beacons) {
    algorithm->setNearestBeacons(beacons);
    
//    printf("NPXStepBasedTEngine: Here OK!");
    
    IPXPoint newLocation = getIndependentLocation();
    
    if (newLocation == INVALID_POINT) {
        return;
    }
    
    if (currentAnchorLocation == INVALID_POINT) {
        currentAnchorLocation = newLocation;
        currentDisplayLocation = newLocation;
        xMovingAverage.clear();
        yMovingAverage.clear();
        xMovingAverage.push(newLocation.getX());
        yMovingAverage.push(newLocation.getY());
    } else {
        if (stepCount == DefaultStep) {
            xMovingAverage.push(newLocation.getX());
            yMovingAverage.push(newLocation.getY());
            currentDisplayLocation = IPXPoint(xMovingAverage.getAverage(),
                                              yMovingAverage.getAverage(), newLocation.getFloor());
        } else {
            double length = stepCount * DefaultStepLength;
            double distance = IPXPoint::DistanceBetween(newLocation,
                                                        currentAnchorLocation);
            
            if (distance < length) {
                currentAnchorLocation = newLocation;
                currentDisplayLocation = newLocation;
                stepCount = DefaultStep;
                xMovingAverage.clear();
                yMovingAverage.clear();
            } else {
                currentDisplayLocation = scalePointWithCenter(currentAnchorLocation, newLocation, length);
            }
        }
    }
}

void NPXStepBasedEngine::addStepEvent() {
    stepCount++;
}

void NPXStepBasedEngine::reset()
{
    stepCount = DefaultStep;
    xMovingAverage.clear();
    yMovingAverage.clear();
    currentAnchorLocation = INVALID_POINT;
    currentDisplayLocation = INVALID_POINT;
}

IPXPoint NPXStepBasedEngine::getLocation() const {
    return currentDisplayLocation;
}

IPXPoint NPXStepBasedEngine::getIndependentLocation() {
    IPXPoint currentLocation = algorithm->calculationLocation();
    return currentLocation;
}
