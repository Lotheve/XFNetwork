//
//  XFUploadAPI.h
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFAPI.h"

typedef NS_ENUM(NSInteger , XFMimeType) {
    XFMimeTypeJS = 0,
    XFMimeTypeCSS,
    XFMimeTypeTXT,
    XFMimeTypeHTML,
    XFMimeTypePNG,
    XFMimeTypeJPG,
    XFMimeTypeGIF,
    XFMimeTypeMP4,
    XFMimeTypeData
};

@interface XFUploadInfo : NSObject

@property(nonatomic,strong)NSData *data;

@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSString *fileName;

@property (nonatomic, assign) XFMimeType mimeType;

@property(nonatomic,strong)NSURL *fileURL;

-(NSString *)mimeTypeString;

+ (instancetype)instanceWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(XFMimeType)mimeType;

+ (instancetype)instanceWithFileURL:(NSURL *)fileURL name:(NSString *)name fileName:(NSString *)fileName mimeType:(XFMimeType)mimeType;

@end

@interface XFUploadAPI : XFAPI

/**
 * 上传数据数组
 */
@property (nonatomic, strong) NSArray <XFUploadInfo *>* uploadInfos;

@end
