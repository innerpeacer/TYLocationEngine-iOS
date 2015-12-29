//
//  IPBLEWebUploader.h
//  BLEProject
//
//  Created by innerpeacer on 15/12/29.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPBLEWebUploader;

@protocol IPBLEWebUploaderDelegate <NSObject>

- (void)WebUploaderDidFinishUploading:(IPBLEWebUploader *)uploader WithApi:(NSString *)api WithResponseData:(NSData *)responseData ResponseString:(NSString *)responseString;
- (void)WebUploaderDidFailedUploading:(IPBLEWebUploader *)uploader WithApi:(NSString *)api WithError:(NSError *)error;

@end

@interface IPBLEWebUploader : NSObject

@property (nonatomic, weak) id<IPBLEWebUploaderDelegate> delegate;

- (id)initWithHostName:(NSString *)hostName;
- (void)uploadWithApi:(NSString *)api Parameters:(NSDictionary *)params;

@end
