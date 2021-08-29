//
//  NSMutableURLRequest+XURLRequest.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/19.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 快速构建一个请求
@interface NSMutableURLRequest (XURLRequest)

/// 快速构建GET请求
/// @param URLString 地址
+ (nullable instancetype)xcr_GETRequestURLString:(NSString *)URLString;

/// 快速构建GET请求
/// @param URLString 地址
/// @param headerFields 头部参数
+ (nullable instancetype)xcr_GETRequestURLString:(NSString *)URLString
                                    headerFields:(nullable NSDictionary *)headerFields;

/// 快速构建GET请求
/// @param URLString 地址
/// @param headerFields 头部参数
/// @param body 请求参数
+ (nullable instancetype)xcr_GETRequestURLString:(NSString *)URLString
                                    headerFields:(nullable NSDictionary *)headerFields
                                            body:(nullable id)body;

/// 快速构建请求
/// @param URLString 地址
/// @param method 请求方法
/// @param headerFields 头部参数
/// @param body 请求参数
+ (nullable instancetype)xcr_requestWithURLString:(NSString *)URLString
                                           method:(NSString *)method
                                     headerFields:(nullable NSDictionary *)headerFields
                                             body:(nullable id)body;

@end

NS_ASSUME_NONNULL_END
