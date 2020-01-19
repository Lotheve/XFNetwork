//
//  TBReformer.m
//  XFNetwork-master
//
//  Created by 卢旭峰 on 2020/1/19.
//  Copyright © 2020 Lotheve. All rights reserved.
//

#import "TBReformer.h"

@implementation TBReformer

- (id)reformResponseObject:(id)responseObj forAPI:(XFAPI *)API withError:(NSError **)error
{
    if (!responseObj) {
        *error = [NSError errorWithDomain:@"RequestError" code:1 userInfo:@{NSLocalizedDescriptionKey:@"数据为空!"}];
        return nil;
    }
    
    if ([responseObj isKindOfClass:[NSData class]]) {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:error];
        return jsonObj;
    }
    
    return responseObj;
}

@end
