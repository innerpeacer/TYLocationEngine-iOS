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

typedef std::vector<IPXPbfDBRecord *> PbfRecordVector;

IPXPbfDBAdapter::IPXPbfDBAdapter(const char *dbPath) {
    m_path = dbPath;
}

bool IPXPbfDBAdapter::eraseDatabase()
{
    string errorString = "Error: failed to erase RawData Table";
    string sql = "delete from DATA_COLLECTION";
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare(m_database, sql.c_str(), (int)sql.length(), &statement, NULL);
    if (success != SQLITE_OK) {
        cout << errorString << endl;
        return false;
    }
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        cout << errorString << endl;
        return false;
    }
    return true;
}

bool IPXPbfDBAdapter::insertRecord(innerpeacer::rawdata::IPXPbfDBRecord *record)
{
    if (existRecord(record->dataID)) {
       return updateRecord(record);
    } else {
       return insertNewRecord(record);
    }
}

bool IPXPbfDBAdapter::insertNewRecord(IPXPbfDBRecord *record)
{
    string errorString = "Error: failed to insert data into the database.";
    sqlite3_stmt *stmt = NULL;
    
    ostringstream ostr;
    ostr << "Insert into DATA_COLLECTION (dataID, type, data, description) values ( ?, ?, ?, ?)";
    string sql = ostr.str();
    
    int success = sqlite3_prepare_v2(m_database, sql.c_str(), -1, &stmt, NULL);
    if (success != SQLITE_OK) {
        cout << errorString << endl;
        return false;
    }
    
    sqlite3_bind_text(stmt, 1, record->dataID.c_str(), -1, SQLITE_STATIC);
    sqlite3_bind_int(stmt, 2, record->dataType);
    sqlite3_bind_blob(stmt, 3, record->data, record->dataLength, SQLITE_STATIC);
    sqlite3_bind_text(stmt, 4, record->dataDescription.c_str(), -1, SQLITE_STATIC);
    
    success = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    if (success == SQLITE_ERROR) {
        cout << errorString << endl;
        return false;
    }
    return true;
}

bool IPXPbfDBAdapter::updateRecord(IPXPbfDBRecord *record)
{
    string errorString = "Error: failed to update datas.";
    sqlite3_stmt *stmt = NULL;
    
    ostringstream ostr;
    ostr << "update DATA_COLLECTION set dataID=?, type=?, data=?, description=? where dataID=?";
    string sql = ostr.str();
    
    int success = sqlite3_prepare_v2(m_database, sql.c_str(), -1, &stmt, NULL);
    if (success != SQLITE_OK) {
        cout << errorString << endl;
        return false;
    }
    
    sqlite3_bind_text(stmt, 1, record->dataID.c_str(), -1, SQLITE_STATIC);
    sqlite3_bind_int(stmt, 2, record->dataType);
    sqlite3_bind_blob(stmt, 3, record->data, record->dataLength, SQLITE_STATIC);
    sqlite3_bind_text(stmt, 4, record->dataDescription.c_str(), -1, SQLITE_STATIC);
    sqlite3_bind_text(stmt, 5, record->dataID.c_str(), -1, SQLITE_STATIC);

    success = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    if (success == SQLITE_ERROR) {
        cout << errorString << endl;
        return false;
    }
    return true;
}

bool IPXPbfDBAdapter::existRecord(std::string recordID)
{
    sqlite3_stmt *stmt = NULL;
    ostringstream ostr;
    ostr << "SELECT distinct dataID from DATA_COLLECTION where dataID = '" << recordID << "'";
    string sql = ostr.str();
    
    bool exist = false;
    if (sqlite3_prepare_v2(m_database, sql.c_str(), -1, &stmt, NULL) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            exist = true;
        }
    }
    sqlite3_finalize(stmt);
    return exist;
}

bool IPXPbfDBAdapter::deleteRecord(std::string recordID)
{
    string errorString = "Error: failed to delete data";
  
    sqlite3_stmt *stmt = NULL;

    ostringstream ostr;
    ostr << "delete from DATA_COLLECTION where dataID = '" << recordID << "'";
    string sql = ostr.str();

    int success = sqlite3_prepare(m_database, sql.c_str(), (int)sql.length(), &stmt, NULL);
    if (success != SQLITE_OK) {
        cout << errorString << endl;
        return false;
    }
    
    sqlite3_bind_text(stmt, 1, recordID.c_str(), -1, SQLITE_STATIC);
    
    success = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    if (success == SQLITE_ERROR) {
        cout << errorString << endl;
        return false;
    }
    return true;
}

bool IPXPbfDBAdapter::deleteRecords(IPXPbfDataType dataType)
{
    string errorString = "Error: failed to delete data";
    
    sqlite3_stmt *stmt = NULL;
    
    ostringstream ostr;
    ostr << "delete from DATA_COLLECTION where type = " << dataType;
    string sql = ostr.str();
    
    int success = sqlite3_prepare(m_database, sql.c_str(), (int)sql.length(), &stmt, NULL);
    if (success != SQLITE_OK) {
        cout << errorString << endl;
        return false;
    }
    
    sqlite3_bind_int(stmt, 1, dataType);
    
    success = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    if (success == SQLITE_ERROR) {
        cout << errorString << endl;
        return false;
    }
    return true;
}

std::vector<IPXPbfDBRecord *> IPXPbfDBAdapter::getRecords(IPXPbfDataType type)
{
    PbfRecordVector resultVector;
    
    sqlite3_stmt *stmt = NULL;
    
    ostringstream ostr;
    ostr << "SELECT distinct dataID, type, data, description FROM DATA_COLLECTION  where type = " << type;
    string sql = ostr.str();
    
    int ret = sqlite3_prepare_v2(m_database, sql.c_str(), (int)sql.length(), &stmt, NULL);
    if (ret == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            IPXPbfDBRecord *record = new IPXPbfDBRecord();
            record->dataID = (const char *)sqlite3_column_blob(stmt, 0);
            record->dataType = sqlite3_column_int(stmt, 1);
            
            int dataLength = sqlite3_column_bytes(stmt, 2);
            record->dataLength = dataLength;
//            record.data = new char[dataLength + 1];
            record->data = new char[dataLength];
            memcpy(record->data, (const char *)sqlite3_column_blob(stmt, 2), dataLength);
            if (sqlite3_column_type(stmt, 3) != SQLITE_NULL) {
                record->dataDescription = (const char *)sqlite3_column_text(stmt, 3);
            }
            resultVector.push_back(record);
        }
    }
    sqlite3_finalize(stmt);

    return resultVector;
}

IPXPbfDBRecord * IPXPbfDBAdapter::getRecord(std::string recordID)
{
    IPXPbfDBRecord *record = NULL;
    sqlite3_stmt *stmt = NULL;
    
    ostringstream ostr;
    ostr << "SELECT distinct dataID, type, data, description FROM DATA_COLLECTION  where dataID = '" << recordID << "'";
    string sql = ostr.str();
    
    int ret = sqlite3_prepare_v2(m_database, sql.c_str(), (int)sql.length(), &stmt, NULL);
    if (ret == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            record = new IPXPbfDBRecord();
            record->dataID = (const char *)sqlite3_column_blob(stmt, 0);
            record->dataType = sqlite3_column_int(stmt, 1);
            
            int dataLength = sqlite3_column_bytes(stmt, 2);
            record->dataLength = dataLength;
            record->data = new char[dataLength + 1];
            memcpy(record->data, (const char *)sqlite3_column_blob(stmt, 2), dataLength);
            if (sqlite3_column_type(stmt, 3) != SQLITE_NULL) {
                record->dataDescription = (const char *)sqlite3_column_text(stmt, 3);
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

