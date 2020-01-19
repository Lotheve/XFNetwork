//
//  XFService.m
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import "XFService.h"
#import "XFAPIChannel.h"
#import "XFServiceManager.h"

@implementation XFService

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (![self conformsToProtocol:@protocol(XFServiceProtocol)]) {
            NSAssert(NO, @"Service must conform to XFServiceProtocol");
        }
    }
    return self;
}

@end
