//
//  XFService.h
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFServiceProtocol.h"

/*
 base class of service. Just establish a new class Inherited this to add a service.
 */

@interface XFService : NSObject

@property (nonatomic, strong) NSString *subPath;

@end
