//
//  XFEncryptor.m
//  KHNetwork-master
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018 Lotheve. All rights reserved.
//

#import "XFEncryptor.h"

@implementation XFEncryptor

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (![self conformsToProtocol:@protocol(XFEncryptorProtocol)]) {
            NSAssert(NO, @"Encryptor must conform to XFEncryptorProtocol");
        }
    }
    return self;
}

@end
