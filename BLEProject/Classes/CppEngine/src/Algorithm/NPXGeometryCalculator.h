/*
 * NPXGeometryCalculator.h
 *
 *  Created on: 2014-9-5
 *      Author: innerpeacer
 */

#ifndef NPXGEOMETRYCALCULATOR_H_
#define NPXGEOMETRYCALCULATOR_H_

#include "NPXPoint.h"

using namespace Innerpeacer::BLELocationEngine;

NPXPoint scalePointWithCenter(NPXPoint center, NPXPoint scaledPoint,
		double length);

#endif /* NPXGEOMETRYCALCULATOR_H_ */
