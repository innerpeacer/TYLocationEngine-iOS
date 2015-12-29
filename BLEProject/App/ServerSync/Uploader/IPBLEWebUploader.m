//
//  IPBLEWebUploader.m
//  BLEProject
//
//  Created by innerpeacer on 15/12/29.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#import "IPBLEWebUploader.h"
#import <MKNetworkKit/MKNetworkKit.h>

@interface IPBLEWebUploader()
{
    NSString *apiHostName;
}

@end

@implementation IPBLEWebUploader

- (id)initWithHostName:(NSString *)hostName
{
    self = [super init];
    if (self) {
        apiHostName = hostName;
    }
    return self;
}

- (void)uploadWithApi:(NSString *)api Parameters:(NSDictionary *)params
{
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:apiHostName];
    MKNetworkOperation *op = [engine operationWithPath:api params:params httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(WebUploaderDidFinishUploading:WithApi:WithResponseData:ResponseString:)]) {
            [self.delegate WebUploaderDidFinishUploading:self WithApi:api WithResponseData:[operation responseData] ResponseString:[operation responseString]];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(WebUploaderDidFailedUploading:WithApi:WithError:)]) {
            [self.delegate WebUploaderDidFailedUploading:self WithApi:api WithError:error];
        }
    }];
    [engine enqueueOperation:op];
}

@end
