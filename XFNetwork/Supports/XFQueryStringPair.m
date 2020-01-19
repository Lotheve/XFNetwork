//
//  XFQueryStringPair.m
//  XFStockAccount
//
//  Created by Lotheve on 2018/8/29.
//  Copyright © 2018年 Lotheve. All rights reserved.
//

#import "XFQueryStringPair.h"

static NSString * const XFCharactersToBeEscapedInQueryStringN = @":/?&=;+!@#$()',*";

static NSString * XFPercentEscapedQueryStringKeyFromStringWithEncodingN(NSString *string, NSStringEncoding encoding) {
    
    static NSString * const XFCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";
    
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)XFCharactersToLeaveUnescapedInQueryStringPairKey, (__bridge CFStringRef)XFCharactersToBeEscapedInQueryStringN, CFStringConvertNSStringEncodingToEncoding(encoding));
}

static NSString * XFPercentEscapedQueryStringValueFromStringWithEncodingN(NSString *string, NSStringEncoding encoding) {
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)XFCharactersToBeEscapedInQueryStringN, CFStringConvertNSStringEncodingToEncoding(encoding));
}

@implementation XFQueryStringPair


- (instancetype)initWithField:(id)field value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.field = field;
    self.value = value;
    
    return self;
}

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return XFPercentEscapedQueryStringKeyFromStringWithEncodingN([self.field description], stringEncoding);
    } else {
        return [NSString stringWithFormat:@"%@=%@", XFPercentEscapedQueryStringKeyFromStringWithEncodingN([self.field description], stringEncoding), XFPercentEscapedQueryStringValueFromStringWithEncodingN([self.value description], stringEncoding)];
    }
}

+ (NSArray *)queryStringPairsFromKeyAndValueWithKey:(NSString *)key Value:(id)value
{
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = dictionary[nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:[self queryStringPairsFromKeyAndValueWithKey:(key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey) Value:nestedValue]];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:[self queryStringPairsFromKeyAndValueWithKey:[NSString stringWithFormat:@"%@[]", key] Value:nestedValue]];
            ;
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:[self queryStringPairsFromKeyAndValueWithKey:key Value:obj]];
            
        }
    } else {
        [mutableQueryStringComponents addObject:[[XFQueryStringPair alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}

@end
