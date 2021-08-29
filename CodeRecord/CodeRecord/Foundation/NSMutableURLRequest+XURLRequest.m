//
//  NSMutableURLRequest+XURLRequest.m
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/19.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import "NSMutableURLRequest+XURLRequest.h"
#import "NSString+XSecure.h"

NSArray<NSURLQueryItem *> *XQueryItemsFromKeyAndValue(NSString *key, id value) {
    
    /**
     AFNetworking/AFURLRequestSerialization.m
     
     NSArray * AFQueryStringPairsFromKeyAndValue(NSString *key, id value)
     在GET请求需要参数时，将参数通过NSURLComponents对象拼接到URL后面
     URL: https://www.apple.com/cn
     参数: a=1&b=2&c=3
     计算结果: https://www.apple.com/cn?a=1&b=2&c=3
     */
    NSMutableArray<NSURLQueryItem *> *items = [NSMutableArray array];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)value;
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = dictionary[nestedKey];
            if (nestedValue) {
                [items addObjectsFromArray:XQueryItemsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    }else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)value;
        for (id nestedValue in array) {
            [items addObjectsFromArray:XQueryItemsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
        }
    }else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = (NSSet *)value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [items addObjectsFromArray:XQueryItemsFromKeyAndValue(key, obj)];
        }
    }else {
        NSString *name = [[NSString stringWithFormat:@"%@",key] xcr_URLEncoding];
        NSString *object = [[NSString stringWithFormat:@"%@",value] xcr_URLEncoding];
        [items addObject:[NSURLQueryItem queryItemWithName:name value:object]];
    }
    
    return [items copy];
}

@implementation NSMutableURLRequest (XURLRequest)

+ (nullable instancetype)xcr_GETRequestURLString:(NSString *)URLString {
    return [self xcr_GETRequestURLString:URLString
                            headerFields:nil];
}

+ (nullable instancetype)xcr_GETRequestURLString:(NSString *)URLString
                                    headerFields:(nullable NSDictionary *)headerFields {
    return [self xcr_GETRequestURLString:URLString
                            headerFields:headerFields
                                    body:nil];
}

+ (nullable instancetype)xcr_GETRequestURLString:(NSString *)URLString
                                    headerFields:(nullable NSDictionary *)headerFields
                                            body:(nullable id)body {
    return [self xcr_requestWithURLString:URLString
                                   method:@"GET"
                             headerFields:headerFields
                                     body:body];
}

+ (nullable instancetype)xcr_requestWithURLString:(NSString *)URLString
                                           method:(NSString *)method
                                     headerFields:(nullable NSDictionary *)headerFields
                                             body:(nullable id)body {
    if (![URLString isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSURL *URL = nil;
    NSData *data = nil;
    if ([method.uppercaseString isEqualToString:@"GET"]) {
        NSURLComponents *URLComponents = [NSURLComponents componentsWithString:URLString];
        if (!URLComponents) {
            return nil;
        }
        URLComponents.queryItems = XQueryItemsFromKeyAndValue(nil, body);
        URL = [URLComponents URL];
    }else {
        URL = [NSURL URLWithString:URLString];
        if (body) {
            if ([NSJSONSerialization isValidJSONObject:body]) { //JSON对象
                data = [NSJSONSerialization dataWithJSONObject:body options:(NSJSONWritingPrettyPrinted) error:nil];
            }else if ([body isKindOfClass:[NSData class]]) { //本身就是数据流
                data = body;
            }else if ([body isKindOfClass:[NSString class]]) { //支持UTF-8编码的字符串
                data = [body dataUsingEncoding:NSUTF8StringEncoding];
            }
        }
    }
    if (!URL) {
        return nil;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = method;
    request.HTTPBody = data;
    return request;
}

@end
