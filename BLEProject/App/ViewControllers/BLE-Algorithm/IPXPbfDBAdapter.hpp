//
//  IPXPbfDBAdapter.hpp
//  BLEProject
//
//  Created by innerpeacer on 2017/5/26.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#ifndef IPXPbfDBAdapter_hpp
#define IPXPbfDBAdapter_hpp

#include <stdio.h>
#include <vector>
#include <sqlite3.h>

#include "IPXPbfDBRecord.hpp"

namespace innerpeacer {
    namespace rawdata {
        
        
        class IPXPbfDBAdapter {
        public:
            IPXPbfDBAdapter(const char *dbPath);
            bool open();
            bool close();
            
            bool eraseDatabase();
            
            bool insertRecord(IPXPbfDBRecord *record);
            bool deleteRecord(std::string recordID);
            bool deleteRecords(IPXPbfDataType dataType);
            
            std::vector<IPXPbfDBRecord *> getRecords(IPXPbfDataType type);
            IPXPbfDBRecord *getRecord(std::string recordID);
            
        private:
            bool insertNewRecord(IPXPbfDBRecord *record);
            bool updateRecord(IPXPbfDBRecord *record);
            bool existRecord(std::string recordID);
            
            std::string m_path;
            sqlite3 *m_database;
        };
    }
}

#endif /* IPXPbfDBAdapter_hpp */
