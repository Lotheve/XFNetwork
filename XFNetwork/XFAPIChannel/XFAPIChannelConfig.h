//
//  XFAPIChannelConfig.h
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFAPIChannelConfig : NSObject

// 是否支持无效证书
@property (nonatomic, assign) BOOL allowInvalidCertificates;

// 是否验证证书域名
@property (nonatomic, assign) BOOL validatesDomainName;

// 服务配置
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;

@end

