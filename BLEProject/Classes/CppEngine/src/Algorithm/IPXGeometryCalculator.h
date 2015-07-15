/*
 * IPXGeometryCalculator.h
 *
 *  Created on: 2014-9-5
 *      Author: innerpeacer
 */

#ifndef NPXGEOMETRYCALCULATOR_H_
#define NPXGEOMETRYCALCULATOR_H_

#include "IPXPoint.h"

using namespace Innerpeacer::BLELocationEngine;

IPXPoint scalePointWithCenter(IPXPoint center, IPXPoint scaledPoint,
		double length);

#endif /* NPXGEOMETRYCALCULATOR_H_ */
