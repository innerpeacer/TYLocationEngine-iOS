//
//  IPXPbfDBRecord.hpp
//  BLEProject
//
//  Created by innerpeacer on 2017/5/26.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#ifndef IPXPbfDBRecord_hpp
#define IPXPbfDBRecord_hpp

#include <stdio.h>
#include <string>

namespace innerpeacer {
    namespace rawdata {
        
        typedef enum {
            IPX_PBF_UNKNOWN_DATA = 0,
            
            IPX_PBF_TRACE_DATA = 1,
            IPX_PBF_RAW_DATA = 2,
            
            IPX_PBF_OTHER_DATA = 10,
        } IPXPbfDataType;
        
        
        class IPXPbfDBRecord {
        public:
            std::string dataID;
//            std::string pbfData;
            char *data;
            int dataLength;
            int dataType;
            std::string dataDescription;
            
            IPXPbfDBRecord() {
//                printf("IPXPbfDBRecord constructor\n");
                dataType = IPX_PBF_UNKNOWN_DATA;
                data = NULL;
            }
            
            std::string toString() {
                return dataID;
            }
            
            ~IPXPbfDBRecord() {
//                printf("IPXPbfDBRecord destructor\n");
                if (data) {
                    delete [] data;
                }
            }
            
        };
    }
}

#endif /* PbfDBRecord_hpp */
