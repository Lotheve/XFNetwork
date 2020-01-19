//
//  XFUploadAPI.m
//  XFNetwork
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import "XFUploadAPI.h"

@interface XFUploadInfo()
@property(nonatomic,strong)NSDictionary *mimeTypeDictionary;
@end

@implementation XFUploadInfo

-(instancetype)init
{
    if (self = [super init])
    {
        _mimeTypeDictionary = @{@(XFMimeTypeJS)   : @"text/javascript",
                                @(XFMimeTypeCSS)  : @"text/css",
                                @(XFMimeTypeTXT)  : @"text/plain",
                                @(XFMimeTypeHTML) : @"text/html",
                                @(XFMimeTypePNG)  : @"image/png",
                                @(XFMimeTypeJPG)  : @"image/jpg",
                                @(XFMimeTypeGIF)  : @"image/gif",
                                @(XFMimeTypeMP4)  : @"video/mp4",
                                @(XFMimeTypeData) : @"multipart/form-data",
                                };
    }
    return self;
}

+ (instancetype)instanceWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(XFMimeType)mimeType;
{
    NSParameterAssert(data);
    NSParameterAssert(name);
    NSParameterAssert(fileName);
    NSParameterAssert(mimeType);
    XFUploadInfo *uploadInfo = [[XFUploadInfo alloc] init];
    uploadInfo.data = data;
    uploadInfo.name = name;
    uploadInfo.fileName = fileName;
    uploadInfo.mimeType = mimeType;
    return uploadInfo;
}

+ (instancetype)instanceWithFileURL:(NSURL *)fileURL name:(NSString *)name fileName:(NSString *)fileName mimeType:(XFMimeType)mimeType
{
    NSParameterAssert(fileURL);
    NSParameterAssert(name);
    NSParameterAssert(fileName);
    NSParameterAssert(mimeType);
    XFUploadInfo *uploadInfo = [[XFUploadInfo alloc] init];
    uploadInfo.fileURL = fileURL;
    uploadInfo.name = name;
    uploadInfo.mimeType = mimeType;
    return uploadInfo;
}

-(NSString *)mimeTypeString
{
    if (_mimeTypeDictionary) {
        return [_mimeTypeDictionary objectForKey:[NSNumber numberWithInteger:self.mimeType]];
    }
    return nil;
}

@end

@implementation XFUploadAPI

- (void)dealloc
{
    _uploadInfos = nil;
}

@end
