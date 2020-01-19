//
//  XFAPI.h
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFNetworkBlock.h"
#import "XFReformer.h"
#import "XFService.h"
#import "XFReformer.h"
#import "XFEncryptor.h"

typedef NS_ENUM(NSInteger, APIMethod) {
    APIMethodGet = 0,
    APIMethodPost,
    APIMethodHead,
    APIMethodPut,
    APIMethodDelete,
};

@interface XFAPI : NSObject

/**
 * 请求标识
 */
@property (nonatomic, assign) NSUInteger identifier;

/**
 * 自定义信息
 */
@property (nonatomic,strong) NSDictionary *userInfo;

/**
 * 目标服务
 */
@property (nonatomic, strong) XFService<XFServiceProtocol> *service;

/**
 * 目标URL （优先级低于service）
 */
@property (nonatomic, strong) NSString *absoluteURL;

/**
 * 请求方法
 */
@property (nonatomic, assign) APIMethod method;

/**
 * 参数
 */
@property (nonatomic, strong) NSDictionary *params;

/**
 * HTTP头域
 */
@property (nonatomic,strong) NSDictionary *headerField;

/**
 * HTTP代理信息
 */
@property (nonatomic, strong) NSString *userAgent;

/**
 * 超时时间
 */
@property (nonatomic,assign) NSTimeInterval timeoutInterval;

/**
 * 绑定的task
 */
@property (nonatomic, weak) NSURLSessionTask *sessionTask;

/**
 * 参数编码类型
 */
@property (nonatomic, assign) NSStringEncoding queryStringEncoding;

/**
 * HTTPBody序列化编码类型
 */
@property (nonatomic, assign) NSStringEncoding HTTPBodyEncoding;

/**
 * 是否携带本地cookie 默认YES
 */
@property (nonatomic, assign) BOOL shouldAutomaticallySetCookie;

/**
 * 加解密器
 */
@property (nonatomic, strong) XFEncryptor<XFEncryptorProtocol> *encryptor;

/**
 * reformer 数据处理对象
 */
@property (nonatomic, strong) XFReformer<XFReformerProtocol> *reformer;

/**
 * 请求成功回调句柄
 */
@property (nonatomic, copy) XFAPISuccessBlock successBlock;

/**
 * 请求失败回调句柄
 */
@property (nonatomic, copy) XFAPIFailBlock failBlock;

/**
 * 上行进度回调句柄
 */
@property (nonatomic, copy) XFAPIProgressBlock uploadProgressBlock;

/**
 * 下行进度回调句柄
 */
@property (nonatomic, copy) XFAPIProgressBlock downloadProgressBlock;


/**
 * 发送请求
 */
- (void)start;

/**
 * 取消请求
 */
- (void)cancel;

@end
