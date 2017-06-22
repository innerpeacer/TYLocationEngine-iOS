//
//  IPXRawDataCollection.cpp
//  BLEProject
//
//  Created by innerpeacer on 2017/5/26.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#include "IPXRawDataCollection.hpp"
#include <sstream>

using namespace std;
using namespace innerpeacer::rawdata;

void IPXRawHeadingEvent::toPbf(innerpeacer::rawdata::TYRawHeadingEventPbf *pbf)
{
    pbf->set_timestamp(timestamp);
    pbf->set_heading(heading);
}

void IPXRawStepEvent::toPbf(innerpeacer::rawdata::TYRawStepEventPbf *pbf)
{
    pbf->set_timestamp(timestamp);
}

void IPXRawBeaconSignal::toPbf(innerpeacer::rawdata::TYRawBeaconSignalPbf *pbf)
{
    pbf->set_uuid(uuid);
    pbf->set_major(major);
    pbf->set_minor(minor);
    
    pbf->set_x(x);
    pbf->set_y(y);
    pbf->set_floor(floor);
    
    pbf->set_rssi(rssi);
    pbf->set_accuracy(accuracy);
}

void IPXRawLocation::toPbf(innerpeacer::rawdata::TYRawLocationPbf *pbf)
{
    pbf->set_x(x);
    pbf->set_y(y);
    pbf->set_floor(floor);
}

IPXRawSignalEvent::IPXRawSignalEvent(TYRawSignalEventPbf pbf) : IPXRawEvent(pbf.timestamp()), location(pbf.location()), immediateLocation(pbf.immediatelocation())
{
    for (int i = 0; i < pbf.beacons_size(); ++i) {
        beaconSignalArray.push_back(IPXRawBeaconSignal(pbf.beacons(i)));
    }
}

void IPXRawSignalEvent::toPbf(innerpeacer::rawdata::TYRawSignalEventPbf *pbf)
{
    pbf->set_timestamp(timestamp);
    
    TYRawLocationPbf *locationPbf = new TYRawLocationPbf();
    location.toPbf(locationPbf);
    pbf->set_allocated_location(locationPbf);
    
    TYRawLocationPbf *immeLocationPbf = new TYRawLocationPbf();
    immediateLocation.toPbf(immeLocationPbf);
    pbf->set_allocated_immediatelocation(immeLocationPbf);
    
    for (int i = 0; i < beaconSignalArray.size(); ++i) {
        IPXRawBeaconSignal bs = beaconSignalArray.at(i);
        TYRawBeaconSignalPbf *bsPbf = pbf->add_beacons();
        bs.toPbf(bsPbf);
    }
}

IPXRawDataCollection::IPXRawDataCollection(TYRawDataCollectionPbf pbf) : IPXRawEvent(pbf.timestamp()), dataID(pbf.dataid())
{
    for (int i = 0; i < pbf.stepevents_size(); ++i) {
        stepEventArray.push_back(IPXRawStepEvent(pbf.stepevents(i)));
    }
    
    for (int i = 0; i < pbf.headingevents_size(); ++i) {
        headingEventArray.push_back(IPXRawHeadingEvent(pbf.headingevents(i)));
    }
    
    for (int i = 0; i < pbf.signalevents_size(); ++i) {
        signalEventArray.push_back(IPXRawSignalEvent(pbf.signalevents(i)));
    }
}

void IPXRawDataCollection::addStepEvent(innerpeacer::rawdata::IPXRawStepEvent step)
{
    stepEventArray.push_back(step);
}

void IPXRawDataCollection::addHeadingEvent(innerpeacer::rawdata::IPXRawHeadingEvent heading)
{
    headingEventArray.push_back(heading);
}

void IPXRawDataCollection::addSignalEvent(innerpeacer::rawdata::IPXRawSignalEvent signal)
{
    signalEventArray.push_back(signal);
}

IPXPbfDBRecord *IPXRawDataCollection::toPbfDBRecord()
{
    IPXPbfDBRecord *record = new IPXPbfDBRecord();
    record->dataType = IPX_PBF_RAW_DATA;
    record->dataID = dataID;
    TYRawDataCollectionPbf pbf = toPbf();
    record->dataLength = pbf.ByteSizeLong();
    record->data = new char[record->dataLength];
    pbf.SerializeToArray(record->data, record->dataLength);
    record->dataDescription = dataID;
    return record;
}

IPXRawDataCollection * IPXRawDataCollection::fromPbfDBRecord(IPXPbfDBRecord *record)
{
    TYRawDataCollectionPbf pbf;;
    pbf.ParseFromArray(record->data, record->dataLength);
    return new IPXRawDataCollection(pbf);
}

TYRawDataCollectionPbf IPXRawDataCollection::toPbf()
{
    TYRawDataCollectionPbf pbf;
    pbf.set_timestamp(timestamp);
    pbf.set_dataid(dataID);
    
    for (int i = 0; i < stepEventArray.size(); ++i) {
        IPXRawStepEvent step = stepEventArray.at(i);
        TYRawStepEventPbf *sPbf = pbf.add_stepevents();
        step.toPbf(sPbf);
    }
    
    for (int i = 0; i < headingEventArray.size(); ++i) {
        IPXRawHeadingEvent heading = headingEventArray.at(i);
        TYRawHeadingEventPbf *hPbf = pbf.add_headingevents();
        heading.toPbf(hPbf);
    }
    
    for (int i = 0; i < signalEventArray.size(); ++i) {
        IPXRawSignalEvent signal = signalEventArray.at(i);
        TYRawSignalEventPbf *sPbf = pbf.add_signalevents();
        signal.toPbf(sPbf);
    }
    return pbf;
}

std::string IPXRawDataCollection::toString()
{
    ostringstream ostr;
    ostr << "DataID: " << dataID  << ", Steps: " << stepEventArray.size() << ", Headings: " << headingEventArray.size() << ", Signals: " << signalEventArray.size() << ", Time: " << timestamp;
    return ostr.str();
}
