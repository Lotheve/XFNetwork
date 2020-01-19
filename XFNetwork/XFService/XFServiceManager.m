//
//  XFServiceManager.m
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/15.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import "XFServiceManager.h"
#import "XFService.h"

static NSMutableDictionary<NSString *, Class> *_serviceMap;

@implementation XFServiceManager

+ (void)initialize
{
    if (self == [XFServiceManager class]) {
        _serviceMap = [NSMutableDictionary dictionary];
    }
}

+ (void)registService:(Class)serviceClass
{
    if (serviceClass == NULL || !NSStringFromClass(serviceClass)) {
        NSAssert(NO, @"service illegal!");
        return;
    }
    NSString *serviceKey = NSStringFromClass(serviceClass);
    if (_serviceMap[serviceKey]) {
        return;
    }
    if (![serviceClass isSubclassOfClass:[XFService class]]) {
        NSAssert(NO, @"service must be a subclass of XFService!");
        return;
    }
    @synchronized (self) {
        _serviceMap[serviceKey] = serviceClass;
    }
}

+ (XFService *)serviceForClass:(Class)serviceClass
{
    return [self serviceForClass:serviceClass withSubPath:nil];
}

+ (XFService *)serviceForClass:(Class)serviceClass withSubPath:(NSString *)subPath
{
    if (serviceClass == NULL || !NSStringFromClass(serviceClass)) {
        NSAssert(NO, @"service illegal!");
        return nil;
    }
    NSString *serviceKey = NSStringFromClass(serviceClass);
    if (serviceKey && serviceKey.length > 0) {
        if (!_serviceMap[serviceKey]) {
            [self registService:serviceClass];
        }
        XFService *service = [_serviceMap[serviceKey] new];
        service.subPath = subPath;
        return service;
    }
    NSString *prompt = [NSString stringWithFormat:@"service not found for key : %@",serviceKey];
    NSAssert(NO, prompt);
    return nil;
}

@end
