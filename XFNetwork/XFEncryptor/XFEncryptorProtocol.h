//
//  XFEncryptorProtocol.h
//  KHNetwork-master
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018 Lotheve. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XFEncryptorProtocol <NSObject>

/**
 Encryption
 */
- (id)encrypt:(id)clearData;

/**
 Decryption
 */
- (id)decrypt:(id)cipherData;

@end

NS_ASSUME_NONNULL_END
