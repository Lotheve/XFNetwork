//
//  XFAPIChannelAdaptor.h
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XFAPIChannel;
@class XFAPI;

@interface XFAPIChannelAdaptor : NSObject

+ (XFAPIChannel *)channelForAPI:(XFAPI *)API;

@end
