//
//  IPBLEWebDownloader.h
//  BLEProject
//
//  Created by innerpeacer on 15/12/29.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import <Foundation/Foundation.h>


@class IPBLEWebDownloader;

@protocol IPBLEWebDownloaderDelegate <NSObject>

- (void)WebDownloaderDidFinishDownloading:(IPBLEWebDownloader *)downloader WithApi:(NSString *)api WithResponseData:(NSData *)responseData ResponseString:(NSString *)responseString;
- (void)WebDownloaderDidFailedDownloading:(IPBLEWebDownloader *)downloader WithApi:(NSString *)api WithError:(NSError *)error;

@end

@interface IPBLEWebDownloader : NSObject

@property (nonatomic, weak) id<IPBLEWebDownloaderDelegate> delegate;

- (id)initWithHostName:(NSString *)hostName;
- (void)downloadWithApi:(NSString *)api Parameters:(NSDictionary *)params;

@end
