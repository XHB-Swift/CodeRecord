//
//  NSPropertyListSerialization+XPropertyLoader.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/17.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 从plist文件中加载常见的数据类型
@interface NSPropertyListSerialization (XPropertyLoader)

#pragma mark - 从Plist字节流中读取

+ (nullable NSArray *)xcr_arrayFromPlistData:(NSData *)plistData;
+ (nullable NSMutableArray *)xcr_mutableArrayFromPlistData:(NSData *)plistData;

+ (nullable NSDictionary *)xcr_dictionaryFromPlistData:(NSData *)plistData;
+ (nullable NSMutableDictionary *)xcr_mutableDictionaryFromPlistData:(NSData *)plistData;

#pragma mark - 从Plist文件路径中读取

+ (nullable NSArray *)xcr_arrayFromPlistFile:(NSString *)plistFile;
+ (nullable NSMutableArray *)xcr_mutableArrayFromPlistFile:(NSString *)plistFile;

+ (nullable NSDictionary *)xcr_dictionaryFromPlistFile:(NSString *)plistFile;
+ (nullable NSMutableDictionary *)xcr_mutableDictionaryFromPlistFile:(NSString *)plistFile;

#pragma mark - 从Plist文件名中读取

+ (nullable NSArray *)xcr_arrayFromPlistName:(NSString *)plistName;
+ (nullable NSMutableArray *)xcr_mutableArrayFromPlistName:(NSString *)plistName;

+ (nullable NSDictionary *)xcr_dictionaryFromPlistName:(NSString *)plistName;
+ (nullable NSMutableDictionary *)xcr_mutableDictionaryFromPlistName:(NSString *)plistName;

@end

NS_ASSUME_NONNULL_END
