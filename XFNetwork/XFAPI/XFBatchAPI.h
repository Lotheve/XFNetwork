//
//  XFBatchAPI.h
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFNetworkBlock.h"

@interface XFBatchAPI : NSObject

@property (nonatomic, strong) NSSet *APIs;

@property (nonatomic, copy) XFBatchAPIProgressBlock progressBlock;

@property (nonatomic, copy) XFBatchAPICompletionBlock  completionBlock;

- (void)start;

- (void)cancel;

@end
