//
//  XFReformer.m
//  KHNetwork-master
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018 Lotheve. All rights reserved.
//

#import "XFReformer.h"
#import "XFReformerProtocol.h"

@implementation XFReformer

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (![self conformsToProtocol:@protocol(XFReformerProtocol)]) {
            NSAssert(NO, @"Reformer must conform to XFReformerProtocol");
        }
    }
    return self;
}

@end
