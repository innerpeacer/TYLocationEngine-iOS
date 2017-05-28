//
//  IPXRawDataCollection.hpp
//  BLEProject
//
//  Created by innerpeacer on 2017/5/26.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#ifndef IPXRawDataCollection_hpp
#define IPXRawDataCollection_hpp

#include <stdio.h>
#include <string>
#include <vector>
#include "t_y_raw_data_collection_pbf.pb.h"

namespace innerpeacer {
    namespace rawdata {
        
        class IPXRawEvent {
        public:
            double timestamp;
            
            IPXRawEvent(double time) {
                timestamp = time;
            };
            
            ~IPXRawEvent() {};
        };
        
        class IPXRawHeadingEvent : public IPXRawEvent {
        public:
            double heading;
            
            IPXRawHeadingEvent(double time) : IPXRawEvent(time) {}
            IPXRawHeadingEvent(TYRawHeadingEventPbf pbf) : IPXRawEvent(pbf.timestamp()) {}
            
            void toPbf(TYRawHeadingEventPbf *pbf);
        };
        
        class IPXRawStepEvent : public IPXRawEvent {
        public:
            IPXRawStepEvent(double time) : IPXRawEvent(time) {}
            IPXRawStepEvent(TYRawStepEventPbf pbf) : IPXRawEvent(pbf.timestamp()) {}
            
            void toPbf(TYRawStepEventPbf *pbf);
        };
        
        class IPXRawBeaconSignal {
        public:
            std::string uuid;
            int major;
            int minor;
            
            double x;
            double y;
            int floor;
            
            int rssi;
            double accuracy;
            
            IPXRawBeaconSignal(std::string uuid, int major, int minor, double x, double y, int floor, int rssi, double accuracy): uuid(uuid), major(major), minor(minor), x(x), y(y), floor(floor), rssi(rssi), accuracy(accuracy){};
            IPXRawBeaconSignal(TYRawBeaconSignalPbf pbf): uuid(pbf.uuid()), major(pbf.major()), minor(pbf.minor()), x(pbf.x()), y(pbf.y()), floor(pbf.floor()), rssi(pbf.rssi()), accuracy(pbf.accuracy()){};
            
            void toPbf(TYRawBeaconSignalPbf *pbf);
        };
        
        class IPXRawLocation {
        public:
            double x;
            double y;
            int floor;
            
            IPXRawLocation() {}
            IPXRawLocation(double x, double y, int floor): x(x), y(y), floor(floor) {}
            IPXRawLocation(TYRawLocationPbf pbf): x(pbf.x()), y(pbf.y()), floor(pbf.floor()) {}
            
            void toPbf(TYRawLocationPbf *pbf);
        };
        
        class IPXRawSignalEvent : public IPXRawEvent {
        public:
            std::vector<IPXRawBeaconSignal> beaconSignalArray;
            IPXRawLocation location;
            IPXRawLocation immediateLocation;
            
            IPXRawSignalEvent(double time): IPXRawEvent(time) {}
            IPXRawSignalEvent(double time, IPXRawLocation location, IPXRawLocation immeLocation) : IPXRawEvent(time), location(location), immediateLocation(immeLocation) {}
            IPXRawSignalEvent(double time, IPXRawLocation location, IPXRawLocation immeLocation, std::vector<IPXRawBeaconSignal> &beaconSignal) : IPXRawEvent(time), location(location), immediateLocation(immeLocation), beaconSignalArray(beaconSignal) {}
            IPXRawSignalEvent(TYRawSignalEventPbf pbf);

            void toPbf(TYRawSignalEventPbf *pbf);
        };
        
        class IPXRawDataCollection : public IPXRawEvent {
        public:
            std::string dataID;
            std::vector<IPXRawStepEvent> stepEventArray;
            std::vector<IPXRawHeadingEvent> headingEventArray;
            std::vector<IPXRawSignalEvent> signalEventArray;
            
            IPXRawDataCollection(double time, std::string dataID): IPXRawEvent(time), dataID(dataID) {}
            IPXRawDataCollection(double time, std::string dataID, std::vector<IPXRawStepEvent> &steps, std::vector<IPXRawHeadingEvent> &headings, std::vector<IPXRawSignalEvent> &signals): IPXRawEvent(time), dataID(dataID), stepEventArray(steps), headingEventArray(headings), signalEventArray(signals) {}
            IPXRawDataCollection(TYRawDataCollectionPbf pbf);
            
            TYRawDataCollectionPbf toPbf();
            std::string toString();
        };
    }
}

#endif /* IPXRawDataCollection_hpp */
