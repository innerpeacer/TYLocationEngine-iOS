//
//  IPBLEWebDownloader.m
//  BLEProject
//
//  Created by innerpeacer on 15/12/29.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "IPBLEWebDownloader.h"
#import <MKNetworkKit/MKNetworkKit.h>


@interface IPBLEWebDownloader()
{
    NSString *apiHostName;
}

@end


@implementation IPBLEWebDownloader

- (id)initWithHostName:(NSString *)hostName
{
    self = [super init];
    if (self) {
        apiHostName = hostName;
    }
    return self;
}

- (void)downloadWithApi:(NSString *)api Parameters:(NSDictionary *)params
{
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:apiHostName];
//    MKNetworkOperation *op = [engine operationWithPath:api params:params httpMethod:@"POST"];
    MKNetworkOperation *op = [engine operationWithPath:api params:params httpMethod:@"GET"];
    
    NSLog(@"%@", [op url]);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(WebDownloaderDidFinishDownloading:WithApi:WithResponseData:ResponseString:)]) {
            [self.delegate WebDownloaderDidFinishDownloading:self WithApi:api WithResponseData:[operation responseData] ResponseString:[operation responseString]];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(WebDownloaderDidFailedDownloading:WithApi:WithError:)]) {
            [self.delegate WebDownloaderDidFailedDownloading:self WithApi:api WithError:error];
        }
    }];
    [engine enqueueOperation:op];
    
}

@end
