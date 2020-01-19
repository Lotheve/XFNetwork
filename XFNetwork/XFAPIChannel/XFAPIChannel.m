//
//  XFAPIChannel.m
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import "XFAPIChannel.h"

#import "AFHTTPSessionManager.h"
#import "AFNetworkReachabilityManager.h"

#import "XFAPI.h"
#import "XFDataAPI.h"
#import "XFDownloadAPI.h"
#import "XFUploadAPI.h"
#import "XFQueryStringPair.h"
#import "XFAPIChannelConfig.h"

NSString *const XFNetworkErrorDomain = @"XFNetworkErrorDomain";

@interface XFAPIChannel ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation XFAPIChannel

+ (instancetype)channel
{
    return [self channelWithConfiguration:nil];
}

+ (instancetype)channelWithConfiguration:(XFAPIChannelConfig *)config
{
    NSURLSessionConfiguration *sessionConfiguration;
    AFHTTPSessionManager *manager;
    if (!config) {
        sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        manager.securityPolicy.allowInvalidCertificates = NO;
        manager.securityPolicy.validatesDomainName = YES;
    } else {
        sessionConfiguration = [config sessionConfiguration];
        manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        manager.securityPolicy.allowInvalidCertificates = config.allowInvalidCertificates;
        manager.securityPolicy.validatesDomainName = config.validatesDomainName;
    }
    
    XFAPIChannel *apiChannel = [XFAPIChannel new];
    apiChannel.manager = manager;
    return apiChannel;
}

- (void)sendRequestForAPI:(XFAPI *)API
{
    NSError *error = nil;
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]){
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"Abnormal network connection!"};
        error = [NSError errorWithDomain:XFNetworkErrorDomain code:XFNetworkUnreachableErrorCode userInfo:userInfo];
    }else{
        NSString *URL = API.absoluteURL;
        NSParameterAssert(URL);
        if (!URL){
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"blank host!"};
            error = [NSError errorWithDomain:XFNetworkErrorDomain code:XFNetworkHostUnreachableErrorCode userInfo:userInfo];
        }
    }
    
    NSMutableURLRequest *request = nil;

    if (!error) {
        NSError *serializationError = nil;
        request = [self buildTaskForAPI:API error:&serializationError];
        if (serializationError)
        {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:serializationError.localizedDescription};
            error = [NSError errorWithDomain:XFNetworkErrorDomain code:XFNetworkUnableParseRequestDataErrorCode userInfo:userInfo];
        }
    }
    if (error) {
        if (API.failBlock) {
            API.failBlock(nil, error, API, nil);
        }
        return;
    }

    NSURLSessionTask *sessionTask = [self sendRequest:request forAPI:API];
    API.sessionTask = sessionTask;
}

-(NSMutableURLRequest *)buildTaskForAPI:(XFAPI *)API error:(NSError *__autoreleasing *)error
{
    APIMethod method = API.method;
    NSString *requestMethod = nil;
    if (method == APIMethodGet)
    {
        requestMethod = @"GET";
    }
    else if(method == APIMethodPost)
    {
        requestMethod = @"POST";
    }
    else if(method == APIMethodHead)
    {
        requestMethod = @"HEAD";
    }
    else if(method == APIMethodPut)
    {
        requestMethod = @"PUT";
    }
    else if(method == APIMethodDelete)
    {
        requestMethod = @"DELETE";
    }
    else
    {
        requestMethod = @"POST";
    }

    if (API.timeoutInterval > 0) {
        _manager.requestSerializer.timeoutInterval = API.timeoutInterval;
    }
    if (API.HTTPBodyEncoding) {
        _manager.requestSerializer.stringEncoding = API.HTTPBodyEncoding;
    }
    if (API.userAgent && API.userAgent.length > 0)
    {
        [_manager.requestSerializer setValue:API.userAgent forHTTPHeaderField:@"User-Agent"];
    }
    _manager.requestSerializer.HTTPShouldHandleCookies = API.shouldAutomaticallySetCookie;
    
    if (API.queryStringEncoding) {
        NSStringEncoding encoding = API.queryStringEncoding;
        [_manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            NSMutableArray *mutablePairs = [NSMutableArray array];
            for (XFQueryStringPair *pair in [XFQueryStringPair queryStringPairsFromKeyAndValueWithKey:nil Value:parameters]) {
                [mutablePairs addObject:[pair URLEncodedStringValueWithEncoding:encoding]];
            }
            return [mutablePairs componentsJoinedByString:@"&"];
        }];
    }
    
    NSMutableURLRequest *taskRequest = nil;
    NSString *URLString = API.absoluteURL;

    id params;
    if (API.encryptor && [API.encryptor respondsToSelector:@selector(encrypt:)]) {
        params = [API.encryptor encrypt:API.params];
    } else {
        params = API.params;
    }
    
    if ([API isKindOfClass:[XFDataAPI class]] || [API isKindOfClass:[XFDownloadAPI class]])
    {
        taskRequest = [_manager.requestSerializer requestWithMethod:requestMethod URLString:URLString parameters:params error:error];
    }
    else if([API isKindOfClass:[XFUploadAPI class]])
    {
        XFUploadAPI *uploadAPI = (XFUploadAPI *)API;
        taskRequest = [_manager.requestSerializer multipartFormRequestWithMethod:requestMethod URLString:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
                       {
                           for (XFUploadInfo *uploadInfo in uploadAPI.uploadInfos)
                           {
                               if (uploadInfo.data)
                               {
                                   [formData appendPartWithFileData:uploadInfo.data name:uploadInfo.name fileName:uploadInfo.fileName mimeType:uploadInfo.mimeTypeString];
                               }
                               else if(uploadInfo.fileURL)
                               {
                                   [formData appendPartWithFileURL:uploadInfo.fileURL name:uploadInfo.name error:nil];
                               }
                           }
                       } error:error];
    }
    
    for (NSString *headerField in API.headerField.allKeys)
    {
        NSString *headerValue = [API.headerField objectForKey:headerField];
        if (headerField.length > 0 && headerValue.length > 0)
        {
            [taskRequest addValue:headerValue forHTTPHeaderField:headerField];
        }
    }

    return taskRequest;
}

- (NSURLSessionTask *)sendRequest:(NSURLRequest *)request forAPI:(XFAPI *)API
{
    NSURLSessionTask *task = nil;
    __weak typeof(self) weakSelf = self;
    
    //Data Request
    if ([API isKindOfClass:[XFDataAPI class]])
    {
        task = [_manager dataTaskWithRequest:request uploadProgress:API.uploadProgressBlock downloadProgress:API.downloadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            [weakSelf handleResponseForAPI:API withResponse:response responseObject:responseObject error:error];
        }];
    }
    //Upload Request
    else if ([API isKindOfClass:[XFUploadAPI class]])
    {
        task = [_manager uploadTaskWithStreamedRequest:request progress:API.uploadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error){
            [weakSelf handleResponseForAPI:API withResponse:response responseObject:responseObject error:error];
        }];
    }
    //Download Request
    else if ([API isKindOfClass:[XFDownloadAPI class]])
    {
        XFDownloadAPI *downloadAPI = (XFDownloadAPI *)API;
        NSAssert(downloadAPI.storagePath, @"storage path could not be empty for download API！");
        
        task = [_manager downloadTaskWithRequest:request progress:API.downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:downloadAPI.storagePath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error){
            [weakSelf handleResponseForAPI:API withResponse:response responseObject:filePath error:error];
        }];
    }
    
    API.identifier = task.taskIdentifier;
    [task resume];
    return task;
}

- (void)handleResponseForAPI:(XFAPI *)API withResponse:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error
{
    if (!error){
        [self handleSuccessForAPI:API withResponse:response responseObjec:responseObject];
    }else{
        [self handleErrorForAPI:API withResponse:response responseObjec:responseObject error:error];
    }
}

- (void)handleSuccessForAPI:(XFAPI *)API withResponse:(NSURLResponse *)response responseObjec:(id)responseObject
{
    id result;
    if (API.encryptor && [API.encryptor respondsToSelector:@selector(decrypt:)]) {
        responseObject = [API.encryptor decrypt:responseObject];
    }
    if (API.reformer && [API.reformer respondsToSelector:@selector(reformResponseObject:forAPI:withError:)])
    {
        NSError *error;
        id obj = [API.reformer reformResponseObject:responseObject forAPI:API withError:&error];
        if (error) {
            [self handleErrorForAPI:API withResponse:response responseObjec:responseObject error:error];
            return;
        }
        result = obj;
    }
    result = result ? : responseObject;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (API.successBlock) {
            API.successBlock(result, API, response);
        }
    });
}

- (void)handleErrorForAPI:(XFAPI *)API withResponse:(NSURLResponse *)response responseObjec:(id)responseObject error:(NSError *)error
{
    if (error && API.failBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            API.failBlock(responseObject, error, API, response);
        });
    }
}

@end
