//
//  XFBatchAPI.m
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import "XFBatchAPI.h"
#import "XFAPI.h"

@implementation XFBatchAPI

- (void)start
{
    if (!_APIs.allObjects.count) {
        if (_completionBlock) {
            _completionBlock(@[],@[]);
        }
        return;
    }
    
    __block int finishedCount = 0;
    void (^APIFinished)(void) = ^(){
        finishedCount++;
        if (self.progressBlock) {
            self.progressBlock(finishedCount, self.APIs.allObjects.count);
        }
    };
    
    NSMutableArray *succeedAPIs = [NSMutableArray array];
    NSMutableArray *failedAPIs = [NSMutableArray array];
    void (^allAPIFinished)(void) = ^(){
        if (self.completionBlock) {
            self.completionBlock(succeedAPIs, failedAPIs);
        }
    };
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_notify(group, dispatch_get_main_queue(), allAPIFinished);
    
    __weak NSMutableArray *weak_succeedAPIs = succeedAPIs;
    __weak NSMutableArray *weak_failedAPIs = failedAPIs;
    
    for (XFAPI *API in _APIs.allObjects) {

        dispatch_group_enter(group);
        
        XFAPISuccessBlock successBlock = API.successBlock;
        XFAPIFailBlock failBlock = API.failBlock;
        API.successBlock = ^(id object, XFAPI *API, NSURLResponse *response) {
            
            __strong NSMutableArray *strong_succeedAPIs = weak_succeedAPIs;
            
            if (successBlock) {
                successBlock(object,API,response);
            }
            [strong_succeedAPIs addObject:API];
            APIFinished();
            dispatch_group_leave(group);
        };
        API.failBlock = ^(id object, NSError *error, XFAPI *API, NSURLResponse *response) {
            
            __strong NSMutableArray *strong_failedAPIs = weak_failedAPIs;
            
            if (failBlock) {
                failBlock(object,error,API,response);
            }
            [strong_failedAPIs addObject:API];
            APIFinished();
            dispatch_group_leave(group);
        };
    }
    
    [_APIs.allObjects makeObjectsPerformSelector:@selector(start)];
}

- (void)cancel
{
    [_APIs.allObjects makeObjectsPerformSelector:@selector(cancel)];
}

- (void)dealloc
{
    _progressBlock = nil;
    _completionBlock = nil;
}

@end
