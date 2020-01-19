//
//  ViewController.m
//  XFNetwork-master
//
//  Created by 卢旭峰 on 2020/1/19.
//  Copyright © 2020 Lotheve. All rights reserved.
//

#import "ViewController.h"
#import <XFNetwork.h>
#import "TBService.h"
#import "TBReformer.h"

@interface ViewController ()

@property (nonatomic, strong) XFDataAPI *dataAPI;
@property (nonatomic, strong) XFDownloadAPI *downloadAPI;
@property (nonatomic, strong) XFUploadAPI *uploadAPI;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)actionDataRequest:(id)sender {
    [self.dataAPI start];
}

- (IBAction)actionDownloadRequest:(id)sender {
    [self.downloadAPI start];
}

- (IBAction)actionUploadRequest:(id)sender {
    [self.uploadAPI start];
}

- (XFDataAPI *)dataAPI
{
    if (!_dataAPI) {
        _dataAPI = [[XFDataAPI alloc] init];
        _dataAPI.method = APIMethodGet;
        _dataAPI.timeoutInterval = 10;
        _dataAPI.params = @{@"code":@"utf-8",@"q":@"卫衣"};
        _dataAPI.service = [XFServiceManager serviceForClass:[TBService class] withSubPath:@"sug"];
        _dataAPI.reformer = [TBReformer new];
        _dataAPI.successBlock = ^(id object, XFAPI *API, NSURLResponse *response) {
            NSLog(@"success : %@",object);
        };
        _dataAPI.failBlock = ^(id object, NSError *error, XFAPI *API, NSURLResponse *response) {
            NSLog(@"error : %@",error.localizedDescription);
        };
    }
    return _dataAPI;
}

- (XFDownloadAPI *)downloadAPI
{
    if (!_downloadAPI) {
        _downloadAPI = [[XFDownloadAPI alloc] init];
        _downloadAPI.method = APIMethodGet;
        _downloadAPI.timeoutInterval = 20;
        _downloadAPI.absoluteURL = @"http://upload-images.jianshu.io/upload_images/1510019-62b6b1eec26730aa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";
        _downloadAPI.storagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"test.png"];
        _downloadAPI.downloadProgressBlock = ^(NSProgress *progress) {
            NSLog(@"download progress : %.2f",progress.fractionCompleted);
        };
        _downloadAPI.successBlock = ^(id object, XFAPI *API, NSURLResponse *response) {
            NSLog(@"download success : %@",object);
        };
        _downloadAPI.failBlock = ^(id object, NSError *error, XFAPI *API, NSURLResponse *response) {
            NSLog(@"download failled : %@",object);
        };
    }
    return _downloadAPI;
}

- (XFUploadAPI *)uploadAPI
{
    if (!_uploadAPI) {
        // TODO
    }
    return _uploadAPI;
}

@end
