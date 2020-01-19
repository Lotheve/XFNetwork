//
//  XFQueryStringPair.h
//  XFStockAccount
//
//  Created by Lotheve on 2018/8/29.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFQueryStringPair : NSObject

@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (instancetype)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;

+ (NSArray *)queryStringPairsFromKeyAndValueWithKey:(NSString *)key Value:(id)value;

@end
