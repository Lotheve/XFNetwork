//
//  XFAPIChannelConfig.m
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import "XFAPIChannelConfig.h"

@implementation XFAPIChannelConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allowInvalidCertificates = NO;
        _validatesDomainName = YES;
        _sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return self;
}

@end
