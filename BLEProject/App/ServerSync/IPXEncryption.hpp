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

std::string ble_decryptString(std::string str);
std::string ble_decryptString(std::string str, std::string key);

std::string ble_encryptString(std::string str);
std::string ble_encryptString(std::string originalString, std::string key);

void ble_encryptBytes(const char *originalBytes, char *encryptedByte, int length);
void ble_encryptBytes(const char *originalBytes, char *encryptedByte, int length, const char *key);

void ble_decryptBytes(const char *encryptedBytes, char *originalBytes, int length);
void ble_decryptBytes(const char *encryptedBytes, char *originalBytes, int length, const char *key);


#endif /* IPXEncryption_hpp */
