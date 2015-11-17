//
//  IPXEncryption.cpp
//  BLEProject
//
//  Created by innerpeacer on 15/11/15.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#include "IPXEncryption.hpp"
const char *BLE_KEY = "6^)(9-p35@%3#4S!4S0)$Y%%^&5(j.&^&o(*0)$Y%!#O@*GpG@=+@j.&6^)(0-=+";
const char *BLE_PASSWORD_FOR_CONTENT = "innerpeacer-content";

std::string ble_decryptString(std::string str)
{
    return ble_encryptString(str, BLE_KEY);
}

std::string ble_encryptString(std::string originalString)
{
    return ble_encryptString(originalString, BLE_KEY);
}

std::string ble_decryptString(std::string str, std::string key)
{
    return ble_encryptString(str, key);
}

std::string ble_encryptString(std::string originalString, std::string key)
{
    int passLength = (int)strlen(BLE_PASSWORD_FOR_CONTENT);
    int keyLength = (int)key.length();
    
    char passValue[passLength];
    memcpy(&passValue[0], BLE_PASSWORD_FOR_CONTENT, passLength);
    
    char keyValue[keyLength];
    memcpy(&keyValue[0], key.c_str(), keyLength);
    
    int pa_pos = 0;
    for (int i = 0; i < keyLength; ++i) {
        keyValue[i] ^= passValue[pa_pos];
        pa_pos++;
        
        if (pa_pos == passLength) {
            pa_pos = 0;
        }
    }
    
    int originalLength = (int)strlen(originalString.c_str());
    //    char originalValue[originalLength + 1];
    char *originalValue = new char[originalLength + 1];
    memcpy(&originalValue[0], originalString.c_str(), originalLength);
    
    int key_pos = 0;
    for (int i = 0; i < originalLength ; ++i) {
        originalValue[i] ^= keyValue[key_pos];
        key_pos++;
        if (key_pos == keyLength) {
            key_pos = 0;
        }
    }
    originalValue[originalLength] = 0;
    
    std::string result(originalValue);
    delete originalValue;
    return result;
}

void ble_encryptBytes(const char *originalBytes, char *encryptedByte, int length)
{
    ble_encryptBytes(originalBytes, encryptedByte, length, BLE_KEY);
}

void ble_encryptBytes(const char *originalBytes, char *encryptedByte, int length, const char *key)
{
    int passLength = (int)strlen(BLE_PASSWORD_FOR_CONTENT);
    int keyLength = (int)strlen(key);
    
    char passValue[passLength];
    memcpy(&passValue[0], BLE_PASSWORD_FOR_CONTENT, passLength);
    
    char keyValue[keyLength];
    memcpy(&keyValue[0], key, keyLength);
    
    int pa_pos = 0;
    for (int i = 0; i < keyLength; ++i) {
        keyValue[i] ^= passValue[pa_pos];
        pa_pos++;
        
        if (pa_pos == passLength) {
            pa_pos = 0;
        }
    }
    
    int originalLength = length;
    //    printf("Length: %d\n", originalLength);
    memcpy(&encryptedByte[0], originalBytes, originalLength);
    
    int key_pos = 0;
    for (int i = 0; i < originalLength ; ++i) {
        encryptedByte[i] ^= keyValue[key_pos];
        key_pos++;
        if (key_pos == keyLength) {
            key_pos = 0;
        }
    }
    encryptedByte[originalLength] = 0;
    
}

void ble_decryptBytes(const char *encryptedBytes, char *originalBytes, int length)
{
    ble_decryptBytes(encryptedBytes, originalBytes, length, BLE_KEY);
}

void ble_decryptBytes(const char *encryptedBytes, char *originalBytes, int length, const char *key)
{
    ble_encryptBytes(encryptedBytes, originalBytes, length, key);
}