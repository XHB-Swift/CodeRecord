//
//  NSObject+XCoder.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/16.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XCoder)

/// 对象归档
/// @param object 可以被归档的对象
+ (nullable NSData *)xcr_archivedObject:(id)object;

/// 对象解档
/// @param data 目标字节
/// @param expectedClasses 对象预期包含的类型
/// 默认类型：NSData，NSString，NSNull，NSDate，NSDictionary，NSArray，NSSet，NSValue，NSAttributedString
/// expectedClasses大于0时在默认类型后面追加类型
+ (nullable id)xcr_unarchivedData:(NSData *)data forExpectedClasses:(nullable NSArray<Class> *)expectedClasses;

@end

NS_ASSUME_NONNULL_END
