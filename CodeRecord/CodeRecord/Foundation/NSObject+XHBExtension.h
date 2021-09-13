//
//  NSObject+XHBExtension.h
//  CodeRecord
//
//  Created by xiehongbiao on 2021/9/13.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XHBExtension)

+ (nullable NSData *)archivedDataForObject:(id)object;
+ (nullable id)unarchivedObjectFromData:(NSData *)data expectedClasses:(nullable NSArray<Class> *)expectedClasses;

+ (nullable id)objectFromPlistName:(NSString *)plistName
                          inBundle:(nullable NSBundle *)bundle
                            option:(NSPropertyListMutabilityOptions)option;

//判断对象是否包含该属性
- (BOOL)hasPropertyWithName:(NSString *)propertyName;

@end

@interface NSDate (XHBExtension)

- (BOOL)isSameDate:(NSDate *)date;

@end

@interface NSString (XHBExtension)

+ (instancetype)asciiNumberTable;
+ (instancetype)asciiVisibleTable;
+ (instancetype)stringWithRoundedNumber:(NSNumber *)roundedNumber
                                  digit:(NSUInteger)digit
                             unitSymbol:(nullable NSString *)unitSymbol;

- (nullable NSString *)propertyToSetter;
- (nullable NSString *)stringAtIndex:(NSInteger)index;

@end

@interface NSDictionary (XHBExtension)

/// 利用key的映射关系，从字典获取数据
/// @param keysRelation key映射关系
/// data1（数据源）   data2（目标数据）  key关系
/// {k1:v1}         {k2:v1}          {k1:k2}
- (nullable NSDictionary *)valuesForKeysRelation:(NSDictionary *)keysRelation;

/// 对字典的values根据orderedKeys进行排序
/// @param orderedKeys 已排序的key名集合
/// @param string 所有值按顺序组合之后，可加上分割符，默认""
- (nullable NSString *)sortedValuesForOrderedKeys:(NSOrderedSet *)orderedKeys
                                   joinedByString:(nullable NSString *)string;

/// 对字典的values根据orderedKeys进行排序
/// @param orderedKeys 已排序的key名集合
/// @param filterNil 是否过滤nil值
/// @param string 所有值按顺序组合之后，可加上分割符，默认""
- (nullable NSString *)sortedValuesForOrderedKeys:(NSOrderedSet *)orderedKeys
                                        filterNil:(BOOL)filterNil
                                   joinedByString:(nullable NSString *)string;

/// 根据键名集合获取值
/// @param keys 键名
- (NSDictionary *)valuesForKeys:(NSSet *)keys;

/// 是否包含某个值
/// @param key 键名
- (BOOL)containsValueForKey:(id)key;

///=============================================================================
/// 获取字典中指定数据类型
///=============================================================================

- (int)intValueForKey:(id)key;
- (int)intValueForKey:(id)key fallback:(int)fallback;
- (BOOL)boolValueForKey:(id)key;
- (BOOL)boolValueForKey:(id)key fallback:(BOOL)fallback;
- (float)floatValueForKey:(id)key;
- (float)floatValueForKey:(id)key fallback:(float)fallback;
- (double)doubleValueForKey:(id)key;
- (double)doubleValueForKey:(id)key fallback:(double)fallback;
- (NSInteger)integerValueForKey:(id)key;
- (NSInteger)integerValueForKey:(id)key fallback:(NSInteger)fallback;
- (NSUInteger)unsignedIntegerForKey:(id)key;
- (NSUInteger)unsignedIntegerForKey:(id)key fallback:(NSUInteger)fallback;

- (nullable NSArray *)arrayValueForKey:(id)key;
- (nullable NSNumber *)numberValueForKey:(id)key;
- (nullable NSString *)stringValueForKey:(id)key;
- (nullable NSDictionary *)dictionaryValueForKey:(id)key;
- (nullable id)modelValueForKey:(id)key className:(NSString *)className;

@end

@interface NSArray (XHBExtension)

- (nullable id)safeObjectAtIndex:(NSUInteger)index;
- (nullable id)safeObjectAtAnyIndex:(NSInteger)anyIndex;
- (nullable id)safeObjectAtRemindedIndex:(NSUInteger)remindedIndex;

@end

@interface NSMutableArray (XHBExtension)

- (void)reverse;

@end

NS_ASSUME_NONNULL_END
