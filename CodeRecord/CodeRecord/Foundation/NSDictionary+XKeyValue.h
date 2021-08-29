//
//  NSDictionary+XKeyValue.h
//  CodeRecord
//
//  Created by 谢鸿标 on 2020/4/16.
//  Copyright © 2020 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSDictionary (XKeyValue)

/// 利用key的映射关系，从字典获取数据
/// @param keysRelation key映射关系
/// data1（数据源）   data2（目标数据）  key关系
/// {k1:v1}         {k2:v1}          {k1:k2}
- (nullable NSDictionary *)xcr_valuesForKeysRelation:(NSDictionary *)keysRelation;

/// 对字典的values根据orderedKeys进行排序
/// @param orderedKeys 已排序的key名集合
/// @param string 所有值按顺序组合之后，可加上分割符，默认""
- (nullable NSString *)xcr_sortedValuesForOrderedKeys:(NSOrderedSet *)orderedKeys
                                       joinedByString:(nullable NSString *)string;

/// 对字典的values根据orderedKeys进行排序
/// @param orderedKeys 已排序的key名集合
/// @param filterNil 是否过滤nil值
/// @param string 所有值按顺序组合之后，可加上分割符，默认""
- (nullable NSString *)xcr_sortedValuesForOrderedKeys:(NSOrderedSet *)orderedKeys
                                            filterNil:(BOOL)filterNil
                                       joinedByString:(nullable NSString *)string;

/// 根据键名集合获取值
/// @param keys 键名
- (NSDictionary *)xcr_valuesForKeys:(NSSet *)keys;

/// 是否包含某个值
/// @param key 键名
- (BOOL)xcr_containsObjectForKey:(id)key;

///=============================================================================
/// 获取字典中指定数据类型
///=============================================================================

- (int)xcr_intValueForKey:(id)key;
- (BOOL)xcr_boolValueForKey:(id)key;

- (float)xcr_floatValueForKey:(id)key;
- (double)xcr_doubleValueForKey:(id)key;

- (NSInteger)xcr_integerValueForKey:(id)key;
- (NSUInteger)xcr_unsignedIntegerValueForKey:(id)key;

- (nullable NSArray *)xcr_arrayValueForKey:(id)key;
- (nullable NSString *)xcr_stringValueForKey:(id)key;
- (nullable NSNumber *)xcr_numberValueForKey:(id)key;

@end

NS_ASSUME_NONNULL_END
