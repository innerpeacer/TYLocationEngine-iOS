/*
 * IPXMovingAverage.h
 *
 *  Created on: 2014-9-5
 *      Author: innerpeacer
 */

#ifndef NPXMOVINGAVERAGE_H_
#define NPXMOVINGAVERAGE_H_

#include <queue>

namespace Innerpeacer {
namespace BLELocationEngine {

const int DEFAULT_WINDOW = 10;
    
class IPXMovingAverage {
public:
    IPXMovingAverage()
    {
        window = DEFAULT_WINDOW;
    }
    
	IPXMovingAverage(int w)
    {
        window = w;
    }
    
    void push(double value);
    void clear();
    double getAverage() const;
    
	virtual ~IPXMovingAverage(){}
    
private:
    std::queue<double> doubleQueue;
    int window;
    double average;
};

} /* namespace BLELocationEngine */
} /* namespace Innerpeacer */
#endif /* NPXMOVINGAVERAGE_H_ */
