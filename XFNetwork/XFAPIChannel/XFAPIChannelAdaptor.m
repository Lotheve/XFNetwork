//
//  XFAPIChannelAdaptor.m
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import "XFAPIChannelAdaptor.h"
#import "XFAPI.h"
#import "XFAPIChannel.h"
#import "XFService.h"

#define kDefaultAPIChannel @"kDefaultAPIChannel"

static NSMutableDictionary <NSString *, XFAPIChannel *>*_apiChannels = nil;

@implementation XFAPIChannelAdaptor

+ (void)initialize
{
    if (self == [XFAPIChannelAdaptor class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _apiChannels = [NSMutableDictionary dictionary];
            [_apiChannels setObject:[XFAPIChannel channel] forKey:kDefaultAPIChannel];
        });
    }
}

+ (XFAPIChannel *)channelForAPI:(XFAPI *)API
{
    Class serviceCls = [API.service class];
    if (!serviceCls || !NSStringFromClass(serviceCls)) {
        return _apiChannels[kDefaultAPIChannel];
    }
    NSString * serviceKey = NSStringFromClass(serviceCls);
    if (_apiChannels[serviceKey]) {
        return _apiChannels[serviceKey];
    }
    @synchronized (_apiChannels) {
        XFAPIChannel *apiChannel = [serviceCls respondsToSelector:@selector(apiChannelConfiguration)] ? [XFAPIChannel channelWithConfiguration:[serviceCls apiChannelConfiguration]] : [XFAPIChannel channel];
        _apiChannels[serviceKey] = apiChannel;
        return apiChannel;
    }
    return _apiChannels[kDefaultAPIChannel];
}

@end
