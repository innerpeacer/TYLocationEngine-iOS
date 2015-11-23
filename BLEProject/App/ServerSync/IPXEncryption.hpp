//
//  IPXEncryption.hpp
//  BLEProject
//
//  Created by innerpeacer on 15/11/15.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#ifndef IPXEncryption_hpp
#define IPXEncryption_hpp

#include <stdio.h>
#include <string>

namespace Innerpeacer {
    namespace BLETool {
        std::string decryptString(std::string str);
        std::string decryptString(std::string str, std::string key);
        
        std::string encryptString(std::string str);
        std::string encryptString(std::string originalString, std::string key);
        
        void encryptBytes(const char *originalBytes, char *encryptedByte, int length);
        void encryptBytes(const char *originalBytes, char *encryptedByte, int length, const char *key);
        
        void decryptBytes(const char *encryptedBytes, char *originalBytes, int length);
        void decryptBytes(const char *encryptedBytes, char *originalBytes, int length, const char *key);
    }
}



#endif /* IPXEncryption_hpp */
