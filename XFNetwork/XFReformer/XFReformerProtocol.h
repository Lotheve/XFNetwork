//
//  XFReformerProtocol.h
//  KHNetwork-master
//
//  Created by 卢旭峰 on 2018/9/5.
//  Copyright © 2018 Lotheve. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XFAPI;

NS_ASSUME_NONNULL_BEGIN

@protocol XFReformerProtocol <NSObject>

/**
Customize the data conversion method by implementing this method

@param responseObj origin data
@param API API object
@param error error
@return specific url
*/

- (id)reformResponseObject:(id)responseObj forAPI:(XFAPI *)API withError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
