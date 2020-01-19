//
//  XFAPI.m
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import "XFAPI.h"
#import "XFAPIChannel.h"
#import "XFAPIChannelAdaptor.h"
#import "XFService.h"
#import "XFReformer.h"

@implementation XFAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.method = APIMethodPost;
        self.HTTPBodyEncoding = NSUTF8StringEncoding;
        self.shouldAutomaticallySetCookie = YES;
    }
    return self;
}

- (void)start
{
    XFAPIChannel *channel = [XFAPIChannelAdaptor channelForAPI:self];
    [channel sendRequestForAPI:self];
}

-(void)cancel
{
    if (_sessionTask)
    {
        [_sessionTask cancel];
    }
}

- (void)setService:(XFService<XFServiceProtocol>*)service
{
    _absoluteURL = [[NSURL URLWithString:service.subPath? : @"" relativeToURL:[NSURL URLWithString:[[service class] serviceURL]]] absoluteString];
    _service = service;
}

-(void)dealloc
{
    NSLog(@"%s",__func__);
    _successBlock = nil;
    _failBlock = nil;
    _uploadProgressBlock = nil;
    _downloadProgressBlock = nil;
}

@end
