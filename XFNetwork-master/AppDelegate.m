//
//  AppDelegate.m
//  XFNetwork-master
//
//  Created by 卢旭峰 on 2020/1/19.
//  Copyright © 2020 Lotheve. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworkReachabilityManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    return YES;
}

@end
