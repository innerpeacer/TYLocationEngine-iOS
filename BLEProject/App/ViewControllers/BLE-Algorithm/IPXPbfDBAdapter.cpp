//
//  IPXPbfDBAdapter.cpp
//  BLEProject
//
//  Created by innerpeacer on 2017/5/26.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#include "IPXPbfDBAdapter.hpp"
#include "DebugHelper.hpp"
#include <sstream>
#include <iostream>
using namespace std;
using namespace innerpeacer::rawdata;

typedef std::vector<IPXPbfDBRecord> PbfRecordVector;

IPXPbfDBAdapter::IPXPbfDBAdapter(const char *dbPath) {
    m_path = dbPath;
}

std::vector<IPXPbfDBRecord> IPXPbfDBAdapter::getRecords(IPXPbfDataType type)
{
    PbfRecordVector resultVector;
    
    sqlite3_stmt *stmt = NULL;
    
    ostringstream ostr;
    ostr << "SELECT distinct dataID, type, data, description FROM DATA_COLLECTION  where type = " << type;
    string sql = ostr.str();
    
//    stringstream s;
    
    int ret = sqlite3_prepare_v2(m_database, sql.c_str(), (int)sql.length(), &stmt, NULL);
    if (ret == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            IPXPbfDBRecord record;
            record.dataID = (const char *)sqlite3_column_blob(stmt, 0);
            record.dataType = sqlite3_column_int(stmt, 1);
            record.pbfData = (const char *)sqlite3_column_blob(stmt, 2);
            if (sqlite3_column_type(stmt, 3) != SQLITE_NULL) {
                record.dataDescription = (const char *)sqlite3_column_text(stmt, 3);
            }
            
            resultVector.push_back(record);
//            printf("%d\n", (int)record->name.length());
        }
    }
    sqlite3_finalize(stmt);

    return resultVector;
}

IPXPbfDBRecord IPXPbfDBAdapter::getRecord(std::string recordID)
{
    IPXPbfDBRecord record;
    sqlite3_stmt *stmt = NULL;
    
    ostringstream ostr;
    ostr << "SELECT distinct dataID, type, data, description FROM DATA_COLLECTION  where dataID = '" << recordID << "'";
    string sql = ostr.str();
    
    stringstream s;
    
    int ret = sqlite3_prepare_v2(m_database, sql.c_str(), (int)sql.length(), &stmt, NULL);
    if (ret == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            record.dataID = (const char *)sqlite3_column_blob(stmt, 0);
            record.dataType = sqlite3_column_int(stmt, 1);
//            record.pbfData = (const char *)sqlite3_column_blob(stmt, 2);
            record.pbfData = string((const char *)sqlite3_column_blob(stmt, 2));
            
//            const char *blob = (const char *)sqlite3_column_blob(stmt, 2);
//            int count = sqlite3_column_bytes(stmt, 2);
//            for (int i = 0; i < count; ++i) {
//                printf("%d ", blob[i]);
//                if (i % 20 == 0) {
//                    printf("\n");
//                }
//            }
            int dataLength = sqlite3_column_bytes(stmt, 2);
            record.dataLength = dataLength;
            record.data = new char[dataLength + 1];
            memcpy(record.data, (const char *)sqlite3_column_blob(stmt, 2), dataLength);
            
            cout << "Byte Length: " << (int)sqlite3_column_bytes(stmt, 2) << endl;
            cout << "Data Length: " << record.pbfData.length() << endl;
            if (sqlite3_column_type(stmt, 3) != SQLITE_NULL) {
                record.dataDescription = (const char *)sqlite3_column_text(stmt, 3);
            }
        }
    }
    sqlite3_finalize(stmt);
    return record;
}

bool IPXPbfDBAdapter::open()
{
//    CPP_LOG_METHOD
    int ret = sqlite3_open(m_path.c_str(), &m_database);
    if (ret == SQLITE_OK) {
        //        printf("open sucesss: %s\n", m_path.c_str());
        return true;
    }
    //    printf("open failed: %s\n", m_path.c_str());
    return false;
}

bool IPXPbfDBAdapter::close()
{
//    CPP_LOG_METHOD
    return (sqlite3_close(m_database) == SQLITE_OK);
}

