//
//  XFAPIChannel.h
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XFAPIChannelConfig;

typedef NS_ENUM(NSUInteger, XFNetworkErrorCode) {
    XFNetworkUnreachableErrorCode = 0,          //网络连接错误
    XFNetworkHostUnreachableErrorCode,          //无法获取host
    XFNetworkUnableParseRequestDataErrorCode,   //请求数据解析错误
    XFNetworkUnableParseResponseDataErrorCode,  //响应数据解析错误
    XFNetworkDataExceptionErrorCode             //数据异常
};

@class XFAPI;

@interface XFAPIChannel : NSObject

+ (instancetype)channel;

+ (instancetype)channelWithConfiguration:(XFAPIChannelConfig *)config;

- (void)sendRequestForAPI:(XFAPI *)API;

@end
