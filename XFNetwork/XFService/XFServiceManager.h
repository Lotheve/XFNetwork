//
//  XFServiceManager.h
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/15.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFServiceProtocol.h"

@interface XFServiceManager : NSObject

+ (id<XFServiceProtocol>)serviceForClass:(Class)serviceClass;

+ (id<XFServiceProtocol>)serviceForClass:(Class)serviceClass withSubPath:(NSString *)subPath;

@end
