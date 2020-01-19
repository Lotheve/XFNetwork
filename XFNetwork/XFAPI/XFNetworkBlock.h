
//
//  XFNetworkBlock.h
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XFAPI;

//请求成功回调block(对于Download API而言，object为文件路径)
typedef void(^XFAPISuccessBlock)(id object, XFAPI *API, NSURLResponse *response);

//请求失败回调block
typedef void(^XFAPIFailBlock)(id object, NSError *error, XFAPI *API, NSURLResponse *response);

//下载上传过程监听block
typedef void (^XFAPIProgressBlock)(NSProgress *progress);

//批量请求过程回调block
typedef void (^XFBatchAPIProgressBlock)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations);

//批量请求完成回调block
typedef void (^XFBatchAPICompletionBlock)(NSArray *succeedAPIs, NSArray *failedAPIs);

