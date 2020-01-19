//
//  XFDownloadAPI.h
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFAPI.h"


@interface XFDownloadAPI : XFAPI

/**
 * 目标文件存储路径
 */
@property (nonatomic, strong) NSString *storagePath;

@end
