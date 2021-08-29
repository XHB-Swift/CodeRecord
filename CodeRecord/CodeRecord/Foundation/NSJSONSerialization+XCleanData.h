//
//  NSJSONSerialization+XCleanData.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/17.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSJSONSerialization (XCleanData)

/// 过滤JSON对象的NSNull
/// @param JSONObject JSON对象
+ (nullable id)xcr_removeKeysWithNullValuesForJSONObject:(nullable id)JSONObject;

/// 安全解析JSON数据
/// @param data 数据流
/// @param opt 操作
/// @param error 错误
+ (nullable id)xcr_JSONObjectWithData:(NSData *)data
                              options:(NSJSONReadingOptions)opt
                                error:(NSError **)error;

/// JSON对象转成JSON字符串
/// @param object JSON对象
+ (nullable NSString *)xcr_JSONStringFromObject:(id)object;

@end

NS_ASSUME_NONNULL_END
