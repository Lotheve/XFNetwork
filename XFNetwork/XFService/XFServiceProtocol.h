//
//  XFServiceProtocol.h
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XFAPIChannelConfig;
@protocol XFServiceProtocol <NSObject>

/**
 You must implement this method to state the url of specific service.

 @return specific url
 */
+ (nonnull NSString *)serviceURL;

@optional

/**
 To custom a session channel, you should implement this method and return XFAPIChannelConfig for specific service. In this way, you can set different configurations for different services.
 
 @return specific configuration to build session channel
 */
+ (nonnull XFAPIChannelConfig *)apiChannelConfiguration;

@end
